package classes.Items.Consumables 
{
	import classes.GlobalFlags.kGAMECLASS;
	import classes.internals.Utils;
	import classes.Items.Consumable;
	import classes.Items.ConsumableLib;

	public class HairDye extends Consumable 
	{
		private var _color:String;
		
		public function HairDye(id:String, color:String) 
		{
			_color = color.toLowerCase();
			var shortName:String = color + " Dye";
			var longName:String = "a vial of " + _color + " hair dye";
			var value:int = ConsumableLib.DEFAULT_VALUE;
			if (color == "rainbow") value = 100;
			var description:String = "This bottle of dye will allow you to change the color of your hair.  Of course if you don't have hair, using this would be a waste.";
			super(id, shortName, longName, value, description);
		}
		
		override public function canUse():Boolean {
			return true;
		}
		
		override public function useItem():Boolean {
			clearOutput();
			game.menu();
			 
			if (game.player.hairLength > 0) {
				outputText("You have " + game.player.hairColor + " hair.");
				if (game.player.hairColor != _color) game.addButton(0, "Hair", dyeHair);
				else game.addButtonDisabled(0, "Hair", "Your already have " + game.player.hairColor + " hair!");
			} else {
				outputText("You have no hair.");
				game.addButtonDisabled(0, "Hair", "You are bald!");
			}
			
			if (game.player.hasFur()) {
				outputText("\n\nYou have " + game.player.furColor + " fur.");
				if (game.player.furColor != _color) game.addButton(1, "Fur", dyeFur);
				else game.addButtonDisabled(1, "Fur", "Your already have " + _color + " fur!");
			} else if (game.player.hasFeathers() || game.player.hasCockatriceSkin()) {
				outputText("\n\nYou have " + game.player.furColor + " feathers.");
				if (game.player.furColor != _color) game.addButton(1, "Feathers", dyeFeathers);
				else game.addButtonDisabled(1, "Feathers", "Your already have " + _color + " feathers!");
			} else {
				outputText("\n\nYou have no fur.");
				game.addButtonDisabled(1, "Fur", "You have no fur!");
			}

			if (game.player.hasFurryUnderBody()) {
				outputText("\n\nYou have " + game.player.underBody.skin.furColor + " fur on your underbody.");
				if (game.player.furColor != _color) game.addButton(2, "Under Fur", dyeUnderBodyFur);
				else game.addButtonDisabled(2, "Under Fur", "Your already have " + _color + " fur on your underbody!");
			} else if (game.player.hasFeatheredUnderBody()) {
				outputText("\n\nYou have " + game.player.underBody.skin.furColor + " feathers on your underbody.");
				if (game.player.furColor != _color) game.addButton(2, "Under Feathers", dyeUnderBodyFeathers);
				else game.addButtonDisabled(2, "Under Feathers", "Your already have " + _color + " feathers on your underbody!");
			} else {
				outputText("\n\nYou have no special or furry underbody.");
				game.addButtonDisabled(2, "Under Fur", "You have no special or furry underbody!");
			}

			if (game.player.wings.canDye()) {
				outputText("\n\nYou have [wingColor] wings.");
				if (!game.player.wings.hasDyeColor(_color)) game.addButton(3, "Wings", dyeWings);
				else game.addButtonDisabled(3, "Wings", "Your already have " + _color + " wings!");
			} else {
				outputText("\n\nYour wings can't be dyed.");
				game.addButtonDisabled(3, "Wings", "Your wings can't be dyed!");
			}

			if (game.player.neck.canDye()) {
				outputText("\n\nYou have a [neckColor] neck.");
				if (!game.player.neck.hasDyeColor(_color)) game.addButton(5, "Neck", dyeNeck);
				else game.addButtonDisabled(5, "Neck", "Your already have a " + _color + " neck!");
			} else {
				outputText("\n\nYour neck can't be dyed.");
				game.addButtonDisabled(5, "Neck", "Your neck can't be dyed!");
			}

			if (game.player.rearBody.canDye()) {
				outputText("\n\nYou have a [rearBodyColor] rear body.");
				if (!game.player.rearBody.hasDyeColor(_color)) game.addButton(6, "Rear Body", dyeRearBody);
				else game.addButtonDisabled(6, "Rear Body", "Your already have a " + _color + " rear body!");
			} else {
				outputText("\n\nYour rear body can't be dyed.");
				game.addButtonDisabled(6, "Rear Body", "Your rear body can't be dyed!");
			}

			game.addButton(4, "Nevermind", dyeCancel);
			return true;
		}
		
		private function dyeHair():void {
			clearOutput();
			if (game.player.hairLength == 0) {
				outputText("You rub the dye into your bald head, but it has no effect.");
			}
			else if (game.player.hairColor.indexOf("rubbery") != -1 || game.player.hairColor.indexOf("latex-textured") != -1) {
				outputText("You massage the dye into your " + game.player.hairDescript() + " but the dye cannot penetrate the impermeable material your hair is composed of.");
			}
			else {
				outputText("You rub the dye into your " + game.player.hairDescript() + ", then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
				game.player.hairColor = _color;
				outputText("You now have " + game.player.hairDescript() + ".");
				if (game.player.lust100 > 50) {
					outputText("\n\nThe cool water calms your urges somewhat, letting you think more clearly.");
					game.dynStats("lus", -15);
				}
			}
			game.inventory.itemGoNext();
		}
		
		private function dyeFur():void {
			clearOutput();
			outputText("You rub the dye into your fur, then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.furColor = _color;
			outputText("You now have " + game.player.furColor + " fur.");
			finalize();
		}
		
		private function dyeUnderBodyFur():void
		{
			clearOutput();
			outputText("You rub the dye into your fur on your underside, then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.underBody.skin.furColor = _color;
			outputText("You now have " + game.player.underBody.skin.furColor + " fur on your underside.");
			finalize();
		}

		private function dyeFeathers():void
		{
			clearOutput();
			outputText("You rub the dye into your feathers, then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.furColor = _color;
			outputText("You now have " + game.player.furColor + " feathers.");
			finalize();
		}

		private function dyeUnderBodyFeathers():void
		{
			clearOutput();
			outputText("You rub the dye into your feathers on your underside, then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.underBody.skin.furColor = _color;
			outputText("You now have " + game.player.underBody.skin.furColor + " feathers on your underside.");
			finalize();
		}

		private function dyeWings():void
		{
			clearOutput();
			outputText("You rub the dye into your [wings], then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.wings.applyDye(_color);
			outputText("You now have [wingColor] wings.");
			finalize();
		}

		private function dyeNeck():void
		{
			clearOutput();
			outputText("You rub the dye onto your [neck], then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.neck.applyDye(_color);
			outputText("You now have a [neckColor] neck.");
			finalize();
		}

		private function dyeRearBody():void
		{
			clearOutput();
			outputText("You rub the dye onto your [rearBody], then use a bucket of cool lakewater to rinse clean a few minutes later.  ");
			game.player.rearBody.applyDye(_color);
			outputText("You now have a [rearBodyColor] rear body.");
			finalize();
		}

		private function dyeCancel():void {
			clearOutput();
			outputText("You put the dye away.\n\n");
			game.inventory.returnItemToInventory(this);
		}

		private function finalize():void
		{
			if (game.player.lust100 > 50) {
				outputText("\n\nThe cool water calms your urges somewhat, letting you think more clearly.");
				game.dynStats("lus", -15);
			}
			game.inventory.itemGoNext();
		}
	}
}
