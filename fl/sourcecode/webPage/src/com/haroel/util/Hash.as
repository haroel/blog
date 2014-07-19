package com.haroel.util
{
	import flash.utils.Dictionary;
	/**
	 * 哈希表
	 * @author fanshuhua
	 * 
	 */
	public dynamic class Hash extends Object
	{
		private var _hash:Dictionary;
		private var _length:int;
		
		/**
		 * 构造方法 
		 * weakKeys = false ,  自动 delete 
		 */		
		public function Hash(weakKeys:Boolean = false)
		{
			super();
			init(weakKeys);
		}
		/**
		 * 初始化 
		 */		
		public function init(weakKeys:Boolean = false):void
		{
			_hash = new Dictionary(weakKeys);
			_length = 0;
		}
		/**
		 * 长度 
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * 添加元素 
		 * @param key 键
		 * @param value 值
		 * @return 添加结果 成功true 失败false
		 * 
		 */		
		public function addItem(key:Object,value:Object):Boolean
		{
			if(hasItem(key)){
				return false;
			}else{
				_hash[key] = value;
				_length++;
				return value;
			}
		}
		/**
		 * 删除元素 
		 * @param child
		 * @return 
		 * 
		 */		
		public function removeItem(key:Object):Object
		{
			if(!getItem(key)){
				return null;
			}else{
				var resultValue:Object = _hash[key];
				delete _hash[key];
				_length--;
				return resultValue;
			}
		}
		/**
		 * 清除所有数据并初始化 
		 * @param weakKeys
		 * 
		 */		
		public function removeAllItems(weakKeys:Boolean = false):void
		{
			dispose();
			init(weakKeys);
		}
		/**
		 * 是否存在？ 
		 * @param key
		 * @return 
		 * 
		 */		
		public function hasItem(key:Object):Boolean{
			if(_hash[key]){
				return true;
			}else{
				return false;
			}
		}
		/**
		 * 查找元素 
		 * @param key
		 * @return 
		 * 
		 */		
		public function  getItem(key:Object):Object
		{
			return _hash[key];
		}
		/**
		 * 查找所有元素 
		 * @return 
		 * 
		 */		
		public function get getItems() : Array
		{
			var result:Array = [];
			for(var key:Object in _hash){
				result.push(_hash[key]);
			}
			return result;
		}
		
		/**
		 * 查找所有键 
		 * @return 
		 * 
		 */		
		public function get getkeys():Array
		{
			var result:Array = [];
			for(var key:Object in _hash){
				result.push(key);
			}
			return result;
		}
		
		/**
		 * 获取数据源
		 * @return 
		 * 
		 */		
		public function get hash():Dictionary
		{
			return this._hash;
		}
		/**
		 * 设置数据源 
		 * @param dictionary
		 * 
		 */		
		public function set hash(dictionary:Dictionary) : void
		{
			dispose();
			_hash = dictionary;
			updateLength();
			return;
		}
		/**
		 * 克隆 
		 * @return 
		 * 
		 */		
		public function clone():Hash
		{
			if(_hash)
			{
				var newHash:Hash = new Hash();
				for(var key:Object in hash)
				{
					newHash.addItem(key,_hash[key]); 
				}
				return newHash
			}else{
				return null;
			}
		}
		
		/**
		 * 添加到当前的散列集合中 
		 * @param hash
		 * 
		 */
		public function concat(hash:Hash):void
		{
			if(hash)
			{
				if(_hash == null)
				{
					init();
				}
				var newHash:Dictionary = hash.hash;
				for(var key:Object in newHash)
				{
					addItem(key,newHash[key]);
				}
			}
		}
		/**
		 * 更新长度 
		 * 
		 */		
		private function updateLength():void{
			if(_hash)
			{
				for(var key:Object in _hash)
				{
					_length++;
				}
			}
		}
		/**
		 * 销毁
		 * 
		 */		
		public function dispose():void{
			_hash = null;
			_length = 0;
		}
		
		public function toObject():Object
		{
			var arr:Array = new Array();
			for( var key:Object in _hash)
			{
				arr.push("(" + key +":"+ _hash[key] + ")");
			}
			return arr.join(",");
		}
		
		
	}
	
}