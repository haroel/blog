package com.haroel
{
	import com.haroel.util.Hash;
	import com.haroel.view.MainResLoader;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class ResManager extends EventDispatcher
	{
		public function ResManager(innerCls:InnerCls)
		{
			if (innerCls == null)
			{
				throw new Error("Singleton Class");
			}
		}
		private static var _instance:ResManager;
		public static function getInstance():ResManager
		{
			
			if(_instance == null)
			{
				_instance = new ResManager(new InnerCls());
			}
			return _instance;
		}
		private var _loaderLayer:Sprite;
		
		public function setLoaderLayer(spt:Sprite):void
		{
			_loaderLayer = spt;
		}
		/**
		 * 获取flash资源
		 * @param fileName文件名
		 * @param className文件中的元件名
		 * @return 
		 * 
		 */		
		public static function getResSwf(fileName:String,className:String):Class
		{
			var obj:Object=ApplicationDomain(getRes(fileName))
			var cls:Class =  obj .getDefinition(className) as Class;
			return cls;
		}
		
		/**
		 * 按名字取得资源
		 * @param resName
		 */
		public static function getRes(resName:String):Object
		{
			return ResManager.getInstance()._resHash.getItem(resName);
		}
		
		private var _loader:Loader;
		private var _resHash:Hash = new Hash();

		private var _mainLoaderC:MainResLoader;
		
		public function loadAssets(filePath:String):void
		{
			_mainLoaderC = new MainResLoader(_loaderLayer);
			_mainLoaderC.init();
			
			_loader = new Loader();
			_loader.load(new URLRequest(filePath));

			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.name = getNameByPath(filePath);
		}
		
		private function loadedHandler(evt:Event):void
		{
			var addResult:Boolean;
			if(evt.target is LoaderInfo)
			{
				if(_loader.content is Sprite){
					addResult = _resHash.addItem(_loader.name,evt.target.applicationDomain);
				}else{
					addResult = _resHash.addItem(_loader.name,_loader.content);
				}
				
				dispatchEvent(new Event(Event.COMPLETE));

			}else
			{
				throw new Error("fuck msg");
			}
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader = null;
			_mainLoaderC.cleanLoader();
		}
		
		private function progressHandler(evt:ProgressEvent):void
		{
			var progress:int = Math.ceil(evt.bytesLoaded / evt.bytesTotal*100)==0?1:Math.ceil(evt.bytesLoaded / evt.bytesTotal*100);
			_mainLoaderC.setProgress(progress);
		}
		
		private function errorHandler(evt:Event):void
		{
			throw new Error(evt);
			_mainLoaderC.cleanLoader();
			//			asyncLoadRes();加载出错后暂时不再继续加载以后的资源
		}
		private function getNameByPath(filePath:String):String
		{
			return  filePath.substring(filePath.lastIndexOf("/") + 1,filePath.lastIndexOf("."));
		}
		private function removeLoader():void
		{
			_mainLoaderC = null;
			while (_loaderLayer.numChildren > 0)
			{
				_loaderLayer.removeChildAt(0);
			}
		}
	}
}
class InnerCls{}