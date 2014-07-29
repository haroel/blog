package com.haroel.view
{
	/**
	 * @ 作者 heh ,2012-2-27
	 * Image 组件 
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class Image extends Bitmap
	{
		private var _source:Object
		private var _urlLoader:URLLoader;
		private var _isLoading:Boolean;
		private var _bitmapData:BitmapData;
		/**
		 * 图片初始化完成将调用该方法 
		 */		
		public var initComplete:Function;
		
		public function Image(source:Object = null)
		{
			super();
			init();
			_source = source;
			loadImageData(false);
		}
		private function init():void
		{
			
		}
		/**
		 *  
		 * @param value url地址或者BitmapData
		 * 
		 */		
		public function set source(value:Object):void
		{
			if(_source == value)
			{
				//				return;
			}
			_source = value;
			loadImageData(true);
		}
		private function loadImageData(value:Boolean):void
		{
			if(!_source)
			{
				if(bitmapData)
				{
					bitmapData.dispose();
				}
				bitmapData= null;
				return;
			}
			if(_source is String)
			{
				if(!_urlLoader)
				{
					_urlLoader = new URLLoader();
				}
				if(value && _isLoading)
				{
					//关闭正在加载的数据
					_urlLoader.close();
				}
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(Event.COMPLETE,loadComplete);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_urlLoader.load(new URLRequest(String(_source)));
				
				_isLoading = true;
			}else if(_source is BitmapData)
			{
				this.bitmapData = _source as BitmapData;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function loadComplete(event:Event):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE,loadComplete);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_isLoading = false;
			var loader:Loader = new Loader();
			loader.loadBytes(_urlLoader.data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadc);
		}
		private function loadc(event:Event):void
		{
			var b:Bitmap = Bitmap(event.target.content);
			this.bitmapData = b.bitmapData.clone();
			b.bitmapData.dispose();
			if(initComplete != null)
			{
				initComplete();
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("无法加载图片资源" + _source)
			_urlLoader.removeEventListener(Event.COMPLETE,loadComplete);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
		}
		/**
		 * 判断当前加载状态，此状态只在source为URL地址时有效 
		 * @return 
		 * 
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function set isLoading(value:Boolean):void
		{
			_isLoading = value;
		}
	}
}