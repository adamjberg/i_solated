package core {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * @author Adam
	 */
	public class TextFactory 
	{
		public static function textField( props:Object ):TextField
		{
			var textField:TextField = new TextField();
			textField.text = props.text;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.setTextFormat( props.textFormat );
			textField.mouseEnabled = false;
			return textField;
		}
		
		public static function textFormat( font:String = 'Times New Roman', size:int = 50, color:uint = 0, align:String = TextFormatAlign.CENTER ):TextFormat
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = color;
			textFormat.font = font;
			textFormat.size = size;
			textFormat.align = align;
			return textFormat;
		}
	}
}
