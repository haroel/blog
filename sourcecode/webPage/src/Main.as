package
{
	import com.haroel.ResManager;
	import com.haroel.events.DDEvent;
	import com.haroel.model.ModelLocator;
	import com.haroel.view.MainResLoader;
	import com.haroel.view.MainUIController;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(width="1000",height="600",frameRate="24",backgroundColor="#f1f1f1")]
	public class Main extends Sprite
	{
		public static const stageWidth:uint = 1000;
		
		public static const stageHeight:uint = 600;
		
		
		
		private var _mainUIController:MainUIController;
		
		private var _uiLayer:Sprite;
		private var _loaderLayer:Sprite;
		
		private var _mainResLoader:MainResLoader;
		
		public function Main()
		{
			super();
			if (stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		private function init(evt:Event = null):void
		{
			if (this.hasEventListener(Event.ADDED_TO_STAGE))
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, init);
			}

			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Security.allowDomain("*");
			
			trace("The running system is " + flash.system.Capabilities.os)
			this.graphics.clear();
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRect(0,0,1000,600);
			this.graphics.endFill();
			
			_uiLayer = new Sprite();
			_loaderLayer = new Sprite();
			
			this.addChild(_uiLayer);
			this.addChild(_loaderLayer);
			
			_mainUIController = new MainUIController();
			_mainUIController.setRoot(_uiLayer);
			
			//读取配置
			ModelLocator.getInstance();
			
			ResManager.getInstance().addEventListener(Event.COMPLETE,mainResLoadCompleteHandler);
			
			ResManager.getInstance().addEventListener(DDEvent.RESMANAGER_START,resManagerHandler);
			ResManager.getInstance().addEventListener(DDEvent.RESMANAGER_PROGRESS,resManagerHandler);
			ResManager.getInstance().addEventListener(DDEvent.RESMANAGER_COMPLETE,resManagerHandler);
			ResManager.getInstance().addEventListener(DDEvent.RESMANAGER_ERROR,resManagerHandler);

			ResManager.getInstance().loadAssets("Webpage.swf");

			_loaderLayer.addEventListener(DDEvent.MAIN_LOADER_REMOVE,initUI);
		}
		private function resManagerHandler(evt:DDEvent):void
		{
			switch(evt.type)
			{
				case DDEvent.RESMANAGER_START:
				{
					_mainResLoader = new MainResLoader();
					_mainResLoader.x = (Main.stageWidth - _mainResLoader.width)/2;							
					_mainResLoader.y = (Main.stageHeight - _mainResLoader.height)/2;
					_loaderLayer.addChild(_mainResLoader);
					break;
				}
				case DDEvent.RESMANAGER_PROGRESS:
				{
					_mainResLoader.setProgress(evt.param as int);
					break;
				}
				case DDEvent.RESMANAGER_COMPLETE:
				{
					mainUILoadOverHandler();
					break;
				}
				case DDEvent.RESMANAGER_ERROR:
				{
					mainUILoadOverHandler();
					break;
				}
				default:
				{
					mainUILoadOverHandler();
					break;
				}
			}
		}
		private function mainUILoadOverHandler():void
		{
			ResManager.getInstance().removeEventListener(DDEvent.RESMANAGER_START,resManagerHandler);
			ResManager.getInstance().removeEventListener(DDEvent.RESMANAGER_PROGRESS,resManagerHandler);
			ResManager.getInstance().removeEventListener(DDEvent.RESMANAGER_COMPLETE,resManagerHandler);
			ResManager.getInstance().removeEventListener(DDEvent.RESMANAGER_ERROR,resManagerHandler);
			
			_mainResLoader.removeLoader();
		}
		private function mainResLoadCompleteHandler(evt:Event):void
		{
			ResManager.getInstance().removeEventListener(Event.COMPLETE,mainResLoadCompleteHandler);			
		}
		private function initUI(evt:Event):void
		{
			_mainResLoader = null;
			_loaderLayer.removeEventListener(DDEvent.MAIN_LOADER_REMOVE,initUI);

			_mainUIController.initView();
			configRightMenu();
		}
		private function configRightMenu():void
		{
			var rightMenu:ContextMenu = new ContextMenu();
			rightMenu.hideBuiltInItems();
			
			var item1:ContextMenuItem = new ContextMenuItem(ModelLocator.VERSION, false, false);
			var item2:ContextMenuItem = new ContextMenuItem("Design by howe");
			rightMenu.customItems.push(item1, item2);
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, gotoHomePage);
			contextMenu = rightMenu;
		}
		
		private function gotoHomePage(evt:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest(ModelLocator.URL), "_blank");
		}
	}
}