package net.pirsquare.anes.inapppurchase
{
	import com.adobe.nativeExtensions.AppPurchase;
	import com.adobe.nativeExtensions.AppPurchaseEvent;
	import com.adobe.nativeExtensions.Product;
	import com.adobe.nativeExtensions.Transaction;
	import com.greensock.TweenLite;
	import com.sleepydesign.system.DebugUtil;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Capabilities;

	import org.osflash.signals.Signal;

	public class InAppPurchaseManager
	{
		/**
		 * Set to true if you want to test via mobile device, default is false;
		 */
		public static var testMode:Boolean = false;

		private static var _getProductsDoneSignal:Signal = new Signal( /*products list*/Vector.<Product>);

		/**
		 * Will return products if available.
		 *
		 * @param productIDs
		 * @return getProductsDoneSignal with Vector.<Product>
		 *
		 */
		public static function getProducts(productIDs:Vector.<String>):Signal
		{
			DebugUtil.trace(" * getProducts" + productIDs);

			AppPurchase.manager.addEventListener(AppPurchaseEvent.PRODUCTS_RECEIVED, onProductsDone);

			var lists:Array = productIDs.toString().split(",");
			AppPurchase.manager.getProducts(lists);

			return _getProductsDoneSignal;
		}

		private static function onProductsDone(event:AppPurchaseEvent):void
		{
			DebugUtil.trace(" ^ onProducts : " + event);

			const products:Array = event.products;

			for each (var p:Product in products)
			{
				DebugUtil.trace(" / -------------------------------------");
				DebugUtil.trace(" ! identifier : " + p.identifier);
				DebugUtil.trace(" ! title : " + p.title);
				DebugUtil.trace(" ! description : " + p.description);
				DebugUtil.trace(" ! price : " + p.price);
				DebugUtil.trace(" ! priceLocale : " + p.priceLocale);
				DebugUtil.trace(" ------------------------------------- /");
			}

			for each (var identifier:String in event.invalidIdentifiers)
				DebugUtil.trace(" ! invalidIdentifiers : " + identifier);

			// TODO : TEST
			_getProductsDoneSignal.dispatch(Vector.<Product>(products));
		}

		private static var _isInit:Boolean = false;

		private static var _donePurchaseSignal:Signal = new Signal(String);

		private static function onRemovedTransaction(e:AppPurchaseEvent):void
		{
			DebugUtil.trace(" ^ onRemovedTransaction : " + e);

			for each (var t:Transaction in e.transactions)
			{
				DebugUtil.trace(" ! Removed : " + t.transactionIdentifier);

				_donePurchaseSignal.dispatch(t.productIdentifier);
			}
		}

		private static function get isAIRDesktop():Boolean
		{
			const os:String = Capabilities.os.split(" ")[0];
			return (Capabilities.playerType == "Desktop") && ((os == "Windows") || (os == "Mac"));
		}

		public static function init():void
		{
			if (isAIRDesktop)
			{
				DebugUtil.trace(" ! [Warning] No in app purchase in desktop mode.");
				return;
			}

			// init only once
			if (_isInit)
				return;

			_isInit = true;

			// wacth for restore
			AppPurchase.manager.addEventListener(AppPurchaseEvent.RESTORE_FAILED, function onRestoreFailed(e:AppPurchaseEvent):void
			{
				DebugUtil.trace(" ^ onRestoreFailed : " + e);
			});

			AppPurchase.manager.addEventListener(AppPurchaseEvent.RESTORE_COMPLETE, function onRestoreComplete(e:AppPurchaseEvent):void
			{
				DebugUtil.trace(" ^ onRestoreComplete : " + e);
			});

			// watch for removed
			AppPurchase.manager.addEventListener(AppPurchaseEvent.REMOVED_TRANSACTIONS, onRemovedTransaction);

			// watch for update
			AppPurchase.manager.addEventListener(AppPurchaseEvent.UPDATED_TRANSACTIONS, function onUpdatedTransaction(e:AppPurchaseEvent):void
			{
				for each (var t:Transaction in e.transactions)
				{
					DebugUtil.trace(" / Transaction ----------------------");

					DebugUtil.trace(" date: " + t.date);
					DebugUtil.trace(" error: " + t.error);
					DebugUtil.trace(" productIdentifier : " + t.productIdentifier);
					DebugUtil.trace(" productQuantity : " + t.productQuantity);
					//DebugUtil.trace("Receipt: " + t.receipt);
					DebugUtil.trace(" state : " + t.state);
					DebugUtil.trace(" transactionIdentifier : " + t.transactionIdentifier);

					DebugUtil.trace(" ---------------------- Transaction /");

					switch (t.state)
					{
						case Transaction.TRANSACTION_STATE_PUCHASING:
						{
							DebugUtil.trace(" ! TRANSACTION_STATE_PUCHASING");
							break;
						}
						case Transaction.TRANSACTION_STATE_PUCHASED:
						{
							DebugUtil.trace(" ! TRANSACTION_STATE_PUCHASED");

							var req:URLRequest = new URLRequest("https://sandbox.itunes.apple.com/verifyReceipt");
							req.method = URLRequestMethod.POST;
							req.data = "{\"receipt-data\" : \"" + t.receipt + "\"}";

							var ldr:URLLoader = new URLLoader(req);

							function onVerified(e:Event):void
							{
								DebugUtil.trace(" ^ onVerified : " + ldr.data);

								// remove transaction
								DebugUtil.trace(" * finish transaction : " + t.transactionIdentifier);
								// TODO : check timeout and retry?
								AppPurchase.manager.finishTransaction(t.transactionIdentifier);
							}

							function onFailed(e:IOErrorEvent):void
							{
								DebugUtil.trace(" ^ fail : " + e);
							}

							ldr.addEventListener(Event.COMPLETE, onVerified);
							ldr.addEventListener(IOErrorEvent.IO_ERROR, onFailed);

							DebugUtil.trace(" * verify : " + t.transactionIdentifier);
							ldr.load(req);

							break;
						}
						case Transaction.TRANSACTION_STATE_RESTORED:
						{
							DebugUtil.trace(" ! TRANSACTION_STATE_RESTORED");

							if (t.originalTransaction.state == Transaction.TRANSACTION_STATE_FAILED || t.originalTransaction.state == Transaction.TRANSACTION_STATE_PUCHASED)
							{
								DebugUtil.trace(" ! original state is faileds or purchased");

								// remove transaction
								DebugUtil.trace(" * finish transaction : " + t.originalTransaction.transactionIdentifier);
								AppPurchase.manager.finishTransaction(t.originalTransaction.transactionIdentifier);
							}

							break;
						}
						case Transaction.TRANSACTION_STATE_FAILED:
						{
							DebugUtil.trace(" ! TRANSACTION_STATE_FAILED");

							// remove transaction anyway...
							// @see http://developer.apple.com/library/IOs/#documentation/NetworkingInternet/Conceptual/StoreKitGuide/AddingaStoretoYourApplication/AddingaStoretoYourApplication.html
							DebugUtil.trace(" * finish transaction : " + t.transactionIdentifier);
							AppPurchase.manager.finishTransaction(t.transactionIdentifier);

							// fail -> null
							_donePurchaseSignal.dispatch(null);

							break;
						}
						default:
						{
							DebugUtil.trace(" ! Finish never call.");
							break;
						}
					}
				}
			});
		}

		public static function purchase(productID:String, quantity:int = 1):Signal
		{
			if (testMode || isAIRDesktop)
			{
				DebugUtil.trace(" ! [Warning] Test mode.");
				DebugUtil.trace(" ! * Simulate done signal in 0.1 secs...");

				// simulate via desktop
				TweenLite.to(_donePurchaseSignal, 0.1, {onComplete: function():void
				{
					// fake fire
					_donePurchaseSignal.dispatch(productID);
				}});

				return _donePurchaseSignal;
			}

			// init yet?
			if (!_isInit)
				init();

			// buy
			DebugUtil.trace(" * start payment");
			AppPurchase.manager.startPayment(productID, quantity);

			return _donePurchaseSignal;
		}

		public static function restore():void
		{
			// init yet?
			if (!_isInit)
				init();

			AppPurchase.manager.restoreTransactions();
		}
	}
}
