package;

import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitGf:FlxSprite;
	var portraitaflac:FlxSprite;
	var portraitaflacangry:FlxSprite;
	var portraitaflacpissed:FlxSprite;
	var portraitaflacconfused:FlxSprite;
	var portraitbfconfused:FlxSprite;
	var portraitaflacmic:FlxSprite;
	var handSelect:FlxSprite;

	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'loaf':
				FlxG.sound.playMusic(Paths.music('Phase1Dialouge'), 0); // why am i so bad at spelling dialogue right
				FlxG.sound.music.fadeIn(4, 0, 0.8);
			case 'blazeborn':
				FlxG.sound.playMusic(Paths.music('Phase2Dialogue'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'loaf':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('aflac/ui/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [4], "", 24);
			case 'blazeborn':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('aflac/ui/dialougeBox2');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [4], "", 24);
			case 'the-end':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('aflac/ui/dialougeBox2');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [4], "", 24);
			case 'chorus':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('aflac/ui/dialougeBox4');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [4], "", 24);
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		if (PlayState.SONG.song.toLowerCase() == 'senpai'
			|| PlayState.SONG.song.toLowerCase() == 'roses'
			|| PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}
		else
		{
			portraitRight = new FlxSprite(380, 170);
			portraitRight.frames = Paths.getSparrowAtlas('aflac/boyfriendPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}

		portraitGf = new FlxSprite(380, 200);
		portraitGf.frames = Paths.getSparrowAtlas('aflac/gfPortrait');
		portraitGf.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitGf.updateHitbox();
		portraitGf.scrollFactor.set();
		add(portraitGf);
		portraitGf.visible = false;

		portraitaflacmic = new FlxSprite(380, 200);
		portraitaflacmic.frames = Paths.getSparrowAtlas('aflac/aflacMicPortrait');
		portraitaflacmic.animation.addByPrefix('enter', 'MicUP', 24, false);
		portraitaflacmic.setGraphicSize(Std.int(portraitaflacmic.width * 0.6));
		portraitaflacmic.updateHitbox();
		portraitaflacmic.scrollFactor.set();
		// portraitaflacmic.x -= 200;
		portraitaflacmic.y -= 50;
		add(portraitaflacmic);
		portraitaflacmic.visible = false;

		portraitaflac = new FlxSprite(600, 174);
		portraitaflac.frames = Paths.getSparrowAtlas('aflac/aflacPortrait');
		portraitaflac.animation.addByPrefix('enter', 'NoMIC', 24, false);
		portraitaflac.setGraphicSize(Std.int(portraitaflac.width * 0.6));
		portraitaflac.updateHitbox();
		portraitaflac.scrollFactor.set();
		portraitaflac.x -= 200;
		add(portraitaflac);
		portraitaflac.visible = false;

		portraitaflacconfused = new FlxSprite(600, 174);
		portraitaflacconfused.frames = Paths.getSparrowAtlas('aflac/aflacConfusedPortrait');
		portraitaflacconfused.animation.addByPrefix('enter', 'Confused', 24, false);
		portraitaflacconfused.setGraphicSize(Std.int(portraitaflacconfused.width * 0.6));
		portraitaflacconfused.updateHitbox();
		portraitaflacconfused.scrollFactor.set();
		portraitaflacconfused.x -= 200;
		add(portraitaflacconfused);
		portraitaflacconfused.visible = false;

		portraitaflacangry = new FlxSprite(350, 200);
		portraitaflacangry.frames = Paths.getSparrowAtlas('aflac/aflacangryPortrait');
		portraitaflacangry.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitaflacangry.setGraphicSize(Std.int(portraitaflacangry.width * 0.5));
		portraitaflacangry.updateHitbox();
		portraitaflacangry.scrollFactor.set();
		add(portraitaflacangry);
		portraitaflacangry.visible = false;

		portraitaflacpissed = new FlxSprite(350, 200);
		portraitaflacpissed.frames = Paths.getSparrowAtlas('aflac/aflacpissedPortrait');
		portraitaflacpissed.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitaflacpissed.setGraphicSize(Std.int(portraitaflacpissed.width * 0.5));
		portraitaflacpissed.updateHitbox();
		portraitaflacpissed.scrollFactor.set();
		add(portraitaflacpissed);
		portraitaflacpissed.visible = false;

		portraitbfconfused = new FlxSprite(350, 200);
		portraitbfconfused.frames = Paths.getSparrowAtlas('aflac/boyfriendConfusedPortrait');
		portraitbfconfused.animation.addByPrefix('enter', 'BF Confused', 24, false);
		portraitbfconfused.setGraphicSize(Std.int(portraitbfconfused.width * 1));
		portraitbfconfused.updateHitbox();
		portraitbfconfused.scrollFactor.set();
		portraitbfconfused.x += 100;
		add(portraitbfconfused);
		portraitbfconfused.visible = false;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('aflac/ui/hand_textbox'));
		add(handSelect);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		if (PlayState.SONG.song.toLowerCase() == 'loaf'
			|| PlayState.SONG.song.toLowerCase() == 'blazeborn'
			|| PlayState.SONG.song.toLowerCase() == 'the-end'
			|| PlayState.SONG.song.toLowerCase() == 'chorus')
		{
			dropText.setFormat(Paths.font("minecraftia.ttf"), 24);
			dropText.color = 0xFFcfcfcf;
		}
		else
		{
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0xFFD89494;
		}
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		if (PlayState.SONG.song.toLowerCase() == 'loaf'
			|| PlayState.SONG.song.toLowerCase() == 'blazeborn'
			|| PlayState.SONG.song.toLowerCase() == 'the-end'
			|| PlayState.SONG.song.toLowerCase() == 'chorus')
			swagDialogue.setFormat(Paths.font("minecraftia.ttf"), 24);
		else
			swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF2e2e2e;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);
			switch PlayState.SONG.song.toLowerCase()
			{
				case 'Roses' | 'Senpai' | 'Thorns':
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				case 'loaf' | 'blazeborn' | 'the-end':
					FlxG.sound.play(Paths.sound('next'), 0.8);
			}

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitaflacangry.visible = false;
				portraitaflacpissed.visible = false;
				portraitaflacmic.visible = false;
				portraitaflac.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitGf.visible = false;
				portraitaflacangry.visible = false;
				portraitaflacpissed.visible = false;
				portraitaflacmic.visible = false;
				portraitaflac.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitbfconfused.visible && !portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bfcon':
				portraitLeft.visible = false;
				portraitGf.visible = false;
				portraitaflacangry.visible = false;
				portraitaflacpissed.visible = false;
				portraitaflacmic.visible = false;
				portraitaflac.visible = false;
				portraitaflacconfused.visible = false;
				portraitRight.visible = false;
				if (!portraitbfconfused.visible && !portraitRight.visible)
				{
					FlxG.sound.play(Paths.sound('confused'), 0.8);
					portraitbfconfused.visible = true;
					portraitbfconfused.animation.play('enter');
				}
			case 'gf':
				portraitaflacpissed.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitaflac.visible = false;
				portraitaflacmic.visible = false;
				portraitaflacangry.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitGf.visible)
				{
					portraitGf.visible = true;
					portraitGf.animation.play('enter');
				}
			case 'aflac':
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitaflacangry.visible = false;
				portraitaflacmic.visible = false;
				portraitaflacpissed.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitaflacconfused.visible && !portraitaflac.visible && !portraitaflacmic.visible)
				{
					portraitaflac.visible = true;
					portraitaflac.animation.play('enter');
				}
			case 'aflacmic':
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitaflacangry.visible = false;
				portraitaflac.visible = false;
				portraitaflacmic.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitaflacconfused.visible && !portraitaflac.visible && !portraitaflacmic.visible)
				{
					portraitaflacmic.visible = true;
					portraitaflacmic.animation.play('enter');
				}
			case 'aflacangry':
				portraitaflacpissed.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitaflacmic.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitaflacangry.visible)
				{
					portraitaflacangry.visible = true;
					portraitaflacangry.animation.play('enter');
				}
			case 'aflaccon':
				portraitaflacpissed.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGf.visible = false;
				portraitaflacangry.visible = false;
				portraitaflacmic.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitaflacconfused.visible && !portraitaflac.visible && !portraitaflacmic.visible)
				{
					FlxG.sound.play(Paths.sound('confused'), 0.8);
					portraitaflacconfused.visible = true;
					portraitaflacconfused.animation.play('enter');
				}
			case 'aflacpissed':
				portraitaflacangry.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitaflac.visible = false;
				portraitaflacmic.visible = false;
				portraitGf.visible = false;
				portraitaflacconfused.visible = false;
				portraitbfconfused.visible = false;
				if (!portraitaflacpissed.visible)
				{
					portraitaflacpissed.visible = true;
					portraitaflacpissed.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
