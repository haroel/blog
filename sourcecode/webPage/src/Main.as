package
{
	import com.haroel.ResManager;
	import com.haroel.model.ModelLocator;
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
			
			ResManager.getInstance().setLoaderLayer(_loaderLayer);
			
			ModelLocator.getInstance();
			ModelLocator.getInstance().addEventListener(Event.COMPLETE,initCompleteHandler);
		}
		private function initCompleteHandler(evt:Event):void
		{
			ModelLocator.getInstance().removeEventListener(Event.COMPLETE,initCompleteHandler);
			
			ResManager.getInstance().loadAssets("Webpage.swf");
			configRightMenu();
			_loaderLayer.addEventListener("MainResLoader_remove",initUI);
		}
		
		private function initUI(evt:Event):void
		{
			_loaderLayer.removeEventListener("MainResLoader_remove",initUI);

			_mainUIController.initView();
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