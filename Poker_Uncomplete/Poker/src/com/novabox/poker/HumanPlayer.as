package com.novabox.poker 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Ophir
	 */
	public class HumanPlayer extends PokerPlayer
	{
		protected var humanUI:Sprite;
		protected var pokerTable:PokerTable;
		protected var raiseValue:TextField;
		
		public function HumanPlayer(_name:String, _stackValue:Number) 
		{
			super(_name, _stackValue);
			humanUI = new Sprite();
			Main.pokerGUI.addChild(humanUI);
			humanUI.x = 700;
			humanUI.y = 700;
			InitUI();
			HideUI();
		}
		
		public function InitUI() : void
		{
			var foldButton:Sprite = CreateButton("Fold", OnFoldClick);
			
			var checkButton:Sprite = CreateButton("Check", OnCheckClick);
			checkButton.x = foldButton.width + 10;
		
			var callButton:Sprite = CreateButton("Call", OnCallClick);
			callButton.x = checkButton.x + checkButton.width + 10;

			var raiseButton:Sprite = CreateButton("Raise", OnRaiseClick);
			raiseButton.x = callButton.x + callButton.width + 10;

			raiseValue = new TextField();
			raiseValue.type = TextFieldType.INPUT;
			raiseValue.x = raiseButton.x ;
			raiseValue.y = raiseButton.y + 20;
			raiseValue.autoSize = TextFieldAutoSize.CENTER;
			raiseValue.background = true;
			raiseValue.backgroundColor = 0xFFFFFF;
			raiseValue.borderColor = 0x000000;
			
			humanUI.addChild(foldButton);
			humanUI.addChild(checkButton);
			humanUI.addChild(callButton);
			humanUI.addChild(raiseButton);
			humanUI.addChild(raiseValue);
		}
		
		public function CreateButton(_label:String, _onClick:Function) : Sprite
		{
			var button:Sprite = new Sprite();
			var label:TextField = new TextField();
			label.text = _label;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.mouseEnabled = false;
			button.addChild(label);
			button.addEventListener(MouseEvent.CLICK, _onClick);
			button.buttonMode = true;
			return button;
		}
		
		public function ShowUI() : void
		{
			if (!humanUI.visible)
			{
				humanUI.visible = true;
				raiseValue.text = pokerTable.GetValueToCall().toString();
			}
		}
		
		public function HideUI() : void
		{
			if (humanUI.visible)
			{
				humanUI.visible = false;
			}
		}

		override public function Play(_pokertable:PokerTable) : Boolean
		{
			pokerTable = _pokertable;
			ShowUI();
			return (lastAction != PokerAction.NONE);
		}
		
		protected function OnCheckClick(_e:Event) : void
		{
			Check();
			HideUI();
		}
		
		protected function OnCallClick(_e:Event) : void
		{
			Call(pokerTable.GetValueToCall());
			HideUI();
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		protected function OnFoldClick(_e:Event) : void
		{
			Fold();
			HideUI();
		}

		protected function OnRaiseClick(_e:Event) : void
		{
			var raiseNumber:Number = Number(raiseValue.text);
			if (raiseNumber)
			{
				Raise(pokerTable.GetValueToCall(), raiseNumber);
				HideUI();
			}
		}
	}

}