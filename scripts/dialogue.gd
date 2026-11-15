const LINES := {
	"cave_1": ["Elder", [
		"Stay here, kid. You were never meant to leave.",
		"The Secret Society hid this cave since the Great War. We keep you safe from outsiders.",
		"Dont even think about the exit. The fences are there for your own good."]],
	"cave_1_gem": ["Elder", [
		"HOLY IS THAT ... THE TIME GEM?!!?!?! HIDE IT, quickly!",
		"Fences hold in the present, But the past is a cave with no fences at all."]],
	"cave_2": ["Mapkeeper", [
		"Outside? There is no outside anymore, only doodoo.",
		"Two rulers fought over the power of the world. Their war tainted the land and tore it in two: a desert, and a winter on the other.",
		"We hide from the world. It is better here."]],
	"cave_3": ["Young Initiate", [
		"I have never seen the sky. They say it is brown like poop with the smoke of war.",
		"The elders say each ruler took a gem of elemental power. Fire for one, ice for the other. They sit on them like babies in a stroller.",
		"I would leave if I could. But nobody can. The way out is blocked."]],
	"cave_4": ["Old Scribe", [
		"I wrote the records of this place myself. Once, this whole continent was a lush forest, so green you would cry of joy.",
		"Then two rulers grew hungry for power. The war burned the land and their gems twisted what was left.",
		"If someone merged the Fire and Ice gems, perhaps the forest could return. But that is a bedtime story. Stay where it is safe."]],
	"cave_5": ["Cave Guard", [
		"Halt. Nobody leaves the Secret Society. Those are the rules.",
		"The world beyond is a wasteland, ruled by two tyrants who squeeze every drop of life from it. We hide it from you for your own good.",
		"Do not touch the fence."]],
	"cave_6": ["Worried Healer", [
		"You look pale. The cold air from the cave does that.",
		"My mother told me the rulers will never stop. The Desert Ruler guards his Fire Gem. The Snow Ruler hugs his Ice Gem.",
		"We pray for a hero, but heroes only live in the stories for babies. Here is better."]],
	"chest_empty": ["", ["The chest is empty now."]],
	"chest_open": ["", [
		"You obtained the Minimap and the Time Gem!",
		"Press M to open the world map. Press T to travel between the Present and the Past."]],
	"fence": ["", ["The way out is blocked by a fence."]],

	"desert_1": ["Parched Traveler", [
		"WATERRR... PLEASSEEE... The Desert War Ruler hoards everything: the water, the shade, EVEN the Fire Gem that broke this land.",
		"He sits in that castle up the stairs while we get cooked into mutton biryani."]],
	"desert_2": ["Weary Vendor", [
		"Business is gone man. Nobody buys spices when the ruler taxes everything.",
		"My grandfather swore this sand was once a forest."]],
	"desert_3": ["Tired Mother", [
		"My children have never seen rain. The ruler's Fire Gem keeps the sun going.",
		"They say a hero will come to end this. I stopped believing years ago."]],
	"desert_4": ["Scarred Guard", [
		"I served in that castle once. The Ruler never sleeps, guarding the Fire Gem like it is his baby.",
		"If you mean to go there, you will need a weapon. Ask the old merchant at the stall. He guards a sword, but he never leaves it."]],
	"desert_5": ["Old Dreamer", [
		"Mind the scorpions, kid. They crawl everywhere since the sands came.",
		"In my dreams the desert is a green sea of trees. I know right? impossible."]],
	"merchant_refuse": ["Special Merchant", [
		"This sword? It is a family heirloom, passed down through my bloodline for generations.",
		"I will not give it away. Not for gold, not for rubies, not for anything.",
		"My grandfather told me it was kept for someone. He never said who."]],
	"merchant_trial": ["Special Merchant", [
		"Wait... you say of two rulers destroying the forest? That is the prophecy my family has repeated for generations.",
		"'One day a hero will come with the glow of heroism, and the sword will be theirs.' So the story goes.",
		"But a prophecy is not proof. Prove yourself in the Trial of the Desert.",
		"Collect 5 scorpions scattered across the desert in 60 seconds. Ready? Go!"]],
	"merchant_retry": ["Special Merchant", [
		"Back to try again? Good. A hero does not give up.",
		"Five scorpions, sixty seconds. Go!"]],
	"merchant_win": ["Special Merchant", [
		"Five scorpions, and with time to spare! You are no ordinary traveler.",
		"The sword is yours, hero. Defeat the war ruler and bring the forest back."]],
	"merchant_after": ["Special Merchant", [
		"The castle awaits, hero. May the sword serve you better than it served my family's dusty shelf."]],
	"ancestor_1": ["Merchant's Ancestor", [
		"Hm? You wear strange clothes, stranger.",
		"War? Time Gem? Two rulers, hungry for the gems of fire and ice, who will poison this green land and split it in two? I can hardly believe it.",
		"Yet your eyes do not lie. If this is the future, then my sword must not be wasted.",
		"I will hand it down through my bloodline, to every child, with one command: give it only to the hero who will defeat the war rulers.",
		"Go, traveler. Tell them the sword was kept for them."]],
	"ancestor_2": ["Merchant's Ancestor", [
		"I have sworn it. The sword will be passed down my bloodline until your hero arrives."]],
	"castle_locked": ["Castle Gate", [
		"The castle gate is sealed with the Desert Ruler's guards behind it.",
		"You would be crushed unarmed. Find a weapon first."]],
	"castle_quiet": ["", ["The castle is silent. The Desert War Ruler has fallen."]],
	"desert_boss": ["Desert War Ruler (RAMA)", [
		"want to hear a joke? your getting my gem!",
		"NEHEHEHHEHEHEHNJCKDBVLUERKBWVBWS"]],

	"snow_1": ["Shivering Villager", [
		"The Snow War Ruler cursed this land to snow forever. My campfire is all that stands between my family and death.",
		"They say the Ice Gem is guarded by the ruler in the fortress north of the lake, but the gate needs a Palace Key, which the rule threw in the lake and locked himself in his fortress for."]],
	"snow_2": ["Fisherman", [
		"I would fish if the lake were not frozen solid. They say the Palace Key sank in its depths when the ruler threw it.",
		"A great tree has blocked the shore since the war began. Nobody can get near the water."]],
	"snow_3": ["Frostbitten Elder", [
		"This snow was soft green grass as I was told when I was a child. Then the rulers' war froze the north and burned the south.",
		"Only if someone claimed both gems and joined them could the land heal. But who could do that?"]],
	"snow_4": ["Curious Child", [
		"The big tree by the lake? Gramps says a tiny sapling grew there once, before the war.",
		"Maybe it is still there, in the old days?"]],
	"snow_5": ["Hooded Seer", [
		"Oh? You have the other two gems? The fortress ruler is crueler than the one in the desert. Faster, tougher, and his ice never melts.",
		"Take the key from the lake, open the gate, and hope the Fire Gem's warmth protects you."]],
	"sapling": ["", ["You carefully uproot the little sapling. A path will open in time."]],
	"sapling_hint": ["", ["The tree in the Present has grown from this very spot..."]],
	"lake_done": ["", ["Nothing else lies in the depths."]],
	"lake_locked": ["", ["The lake glitters under the ice. A great tree stands in your way."]],
	"fortress_locked": ["Fortress Gate", [
		"A heavy iron gate. It needs a Palace Key.",
		"The villagers say the key lies at the bottom of the frozen lake."]],
	"fortress_open": ["Fortress Gate", [
		"The Palace Key turns with a heavy click. The gate groans open..."]],
	"fortress_quiet": ["", ["The fortress is silent. The Snow War Ruler has fallen."]],
	"snow_boss": ["Snow War Ruler (GAMA)", [
		"MMMMMM A VISITOR. HAVENT SEEN ANYONE FOR 50 YEARS",
		"IT SEEMS YOU HAVE THE FIRE GEM. YOU WONT GET THE GEM FROM ME UNLIKE THAT BUFFOON RULER"]],
}
