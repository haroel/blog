package
{
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.ModelLocator;
	import com.haroel.view.MainResLoader;
	import com.haroel.view.MainUIController;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import morn.core.handlers.Handler;
	import morn.core.managers.ResLoader;
	
	[SWF(width="1000",height="600",frameRate="24",backgroundColor="#ffffff")]
	
	public class Main extends Sprite
	{
		public static const stageWidth:uint = 1000;
		
		public static const stageHeight:uint = 600;		
		
		private var _mainUIController:MainUIController;
		
		private var _mainResLoader:MainResLoader;
		
		public function Main()
		{
			super();
			initApp();
//			init();
		}
		private function initApp():void
		{
			trace("flash player version: " + flash.system.Capabilities.version);
			trace("system os version: " + flash.system.Capabilities.os);
			
			App.init(this);
			
			_mainResLoader = new MainResLoader();
			_mainResLoader.x = (Main.stageWidth - _mainResLoader.width)/2;							
			_mainResLoader.y = (Main.stageHeight - _mainResLoader.height)/2;
			App.loaderLayer.addChild(_mainResLoader);
			
			//加载资源配置文件
			var resArray:Array = [{url:ResourceConfig.FILE_GAME_SETTING,type:ResLoader.TXT,size:1},
								ResourceConfig.FILE_WEB_PAGE];
			App.loader.loadAssets(resArray,
				new Handler(loadComplete), 
				new Handler(loadProgress),
				new Handler(loadError));
			function loadError(value:String):void
			{
				trace(value);	
			}
		}

		private function loadProgress(value:Number):void
		{
			var percent:Number = value * 100;
			_mainResLoader.setProgress(percent);
		}
		
		private function loadComplete():void
		{
			trace("主资源加载完成！");
			_mainResLoader.removeLoader(new Handler(mainLoaderRemoveFunc));
			function mainLoaderRemoveFunc():void
			{
				initData();
				initMainUI();
				initRightMenu();
			}
		}
		private function initData():void
		{
			//读取配置
			ModelLocator.getInstance().parseXML(App.loader.getResLoaded(ResourceConfig.FILE_GAME_SETTING));
			
		}
		
		private function initMainUI():void
		{			
			_mainUIController = new MainUIController();
			_mainUIController.setRoot(App.uiLayer);
			_mainUIController.initView();
		}
		private function initRightMenu():void
		{			
			var fpVersion:String = flash.system.Capabilities.version;
			var verary:Array = fpVersion.split(/[,\ ]/); 
			if (verary.length > 3)
			{
				var mainV:int = parseInt(verary[1]);
				var recV:int = parseInt(verary[2]);
				
				var tagV:Number = Number( verary[1] +"." + verary[2] );
				if (tagV >= 11.2)
				{
//					stage.addEventListener(MouseEvent.RIGHT_CLICK, doNothing);
					createSystemRightMenu();
				}
				else
				{
					createSystemRightMenu();
				}
			}
			else
			{
				createSystemRightMenu();
			}
		}
		private function createSystemRightMenu():void
		{
			var rightMenu:ContextMenu = new ContextMenu();
			rightMenu.hideBuiltInItems();
			
			var item1:ContextMenuItem = new ContextMenuItem(ModelLocator.VERSION, true, false);
			rightMenu.customItems.push(item1);
			var labels:Array = ModelLocator.getInstance().getRightMenuLabels();
			
			for each (var obj:Object in labels)
			{
				var rightItem:ContextMenuItem = new ContextMenuItem(obj.label,obj.separatorBefore,obj.enabled);
				rightMenu.customItems.push(rightItem);
			}
			contextMenu = rightMenu;
		}
	}
}