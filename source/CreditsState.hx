package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['Pado Team!'],
		['HeartDieGold', 'alpaka', 'Main artist and creator of PadoPado-Beep\nThe chad Padoru Guy', 'https://twitter.com/HeartDieGold',	0xFFFFDD33],
		['Chemax0204', 'chemax', 'Pro Coder of PadoPado-Beep also Icon Artist\n(Working on VS Goku DEMO btw)', 'https://twitter.com/chemaxgod', 0xFFC30085],
		['AriVane',	'ari', 'Talented and funny Artist', 'https://twitter.com/Vanessa66635?t=YO60-fKfVs4fgBEzNrPNLg&s=09', 0xFFC30085],
		['Caelo Brint', 'carlos', 'Cool Charter\nFun fact, He loves peanuts!', 'https://youtube.com/channel/UCkrVfsCxJOx0NZaGCL367lQ', 0xFF1C43F4],
		['Toni Kyouno', 'koni', 'The chad Musician man', 'https://twitter.com/Koni_jaksj?s=09', 0xFF6F40C2],
		['Fleetway Art', 'furro', 'Cool Artist\nFleetway simp lol', 'https://mobile.twitter.com/ArtFleetway', 0xFFC30085],
		['Koixi_', 'koichi', 'Epic Musican man', 'https://twitter.com/Koixis_?t=UCRpZnKkYq8bMAvBlrWHfQ&s=08', 0xFFC30085],
		['Kidemon', 'kindemon', 'Other cool Artist', 'https://youtube.com/channel/UCG4qBqrjt2-RCMwj6x8w19A', 0xFFF3B020]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var bg:BGSprite = new BGSprite('stageStuff/BackgroundPADO', 0, 0, ['BackPado'], true);
		bg.scale.set(0.7, 0.7);
		bg.updateHitbox();
		bg.screenCenter(X);
		add(bg);

		var snow:FlxSprite = new FlxSprite(0, -20);
		snow.frames = Paths.getSparrowAtlas('Snow_menu_yup');
		snow.animation.addByPrefix('idle', "Símbolo 0", 24);
		snow.animation.play('idle');
		snow.screenCenter(X);
		snow.antialiasing = ClientPrefs.globalAntialiasing;
		snow.alpha = 0.7;
		add(snow);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
