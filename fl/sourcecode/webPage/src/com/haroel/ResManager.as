package com.haroel
{
	import com.haroel.events.DDEvent;
	import com.haroel.util.Hash;
	import com.haroel.view.MainResLoader;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
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
		
		public function isResourceExist(fileName:String):Boolean
		{
			return _resHash.hasItem(fileName);
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
			var obj:Object = ApplicationDomain(getRes(fileName))
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

//		private var _mainLoaderC:MainResLoader;
		
		public function loadAssets(filePath:String):void
		{			
			//加载资源
			_loader = new Loader();
			_loader.load(new URLRequest(filePath));
			
			this.dispatchEvent(new DDEvent(DDEvent.RESMANAGER_START,null));

			//侦听事件
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			_loader.name = getNameByPath(filePath);
			
		}
		
		private function loadedCompleteHandler(evt:Event):void
		{
			//下载完成
			var addResult:Boolean;
			if(evt.target is LoaderInfo)
			{
				if(_loader.content is Sprite)
				{
					addResult = _resHash.addItem(_loader.name,evt.target.applicationDomain);
				}
				else
				{
					addResult = _resHash.addItem(_loader.name,_loader.content);
				}
				trace("资源下载完成" + _loader.name);
				
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				throw new Error("fuck msg");
			}
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			_loader = null;
			
			this.dispatchEvent(new DDEvent(DDEvent.RESMANAGER_COMPLETE,null));
		}
		
		private function progressHandler(evt:ProgressEvent):void
		{
			var progress:int = Math.ceil(evt.bytesLoaded / evt.bytesTotal*100)==0?1:Math.ceil(evt.bytesLoaded / evt.bytesTotal*100);
			this.dispatchEvent(new DDEvent(DDEvent.RESMANAGER_PROGRESS,progress));
		}
		
		private function errorHandler(evt:Event):void
		{
			trace("resmanager error");
			
			this.dispatchEvent(new DDEvent(DDEvent.RESMANAGER_ERROR,evt));
			throw new Error(evt);
		}
		private function getNameByPath(filePath:String):String
		{
			return  filePath.substring(filePath.lastIndexOf("/") + 1,filePath.lastIndexOf("."));
		}

	}
}
class InnerCls{}