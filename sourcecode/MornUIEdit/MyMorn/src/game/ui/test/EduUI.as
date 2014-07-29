/**Created by the Morn,do not modify.*/
package game.ui.test {
	import morn.core.components.*;
	public class EduUI extends View {
		protected static var uiXML:XML =
			<View width="800" height="480">
			  <Label text="2006年7月毕业于湖北省武汉市江夏区实验高中" x="47" y="44" width="346" height="21"/>
			  <Label text="2007年7月毕业于湖北省武汉市江夏区培训中心" x="46" y="86" width="352" height="21"/>
			  <Label text="2011年6月毕业于湖北省武汉市武汉科技大学 信息管理与信息系统专业" x="47" y="134" width="620" height="21"/>
			</View>;
		public function EduUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiXML);
		}
	}
}