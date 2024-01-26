if (GetLocale() ~= "deDE") then
	return
end

GROUPSOCIALAUTOMATION_LOCALIZATIONS = {

	-- options
	options = "Optionen",
	common = "Generelle Einstellungen",

	["langs you speak"] = "Sprachen, die du sprichst",
	["you are playing on"] = "Du spielst auf %s (Server Iso: %s), daher ist %s standardmäßig gewählt und kann auch nicht abgewählt werden.",
	["langs you speak description"] = "Das Addon entscheidet anhand Deiner Auswahl hier, wie es Leute grüßt und verabschiedet. \n\n" .. 
		"Beispiel:\n" ..
		"Du wählst hier >deutsch< und >englisch<. Nun tritt jemand aus Russland deiner M+ Premade-Gruppe bei. Das Addon wird jetzt in der globalen Sprache (EN) grüßen, statt auf russisch, da der beitretende sonst " .. 
		"denken könnte, das du russisch verstehst und möglicherweise mit ihm auf russisch kommunizieren möchtest. Hast du allerdings im selben Szenario auch russisch als von dir gesprochene Sprache " .. 
		"gewählt, so wird das Addon die beitretende Person auch auf russisch grüßen.\n" .. 
		"(Das Addon verwendet die Server Region um zu koordinieren welche Sprache einer Spieler wohl spricht) \n\n" ..
		"Generelle Info: Spieler die über den Dungeonbrowser und Raidbrowser zusammengestellt werden, kommen IMMER von Servern der GLEICHEN Sprache. Wenn du also auf einem deutschen Server spielst, wirst du " ..
		"niemals mit Leuten in eine Gruppe gesteckt, die nicht ebenfalls auf deutschen Servern spielen.",

	["group types to greet hl"] = "Gruppen-Arten ...",
	["group types to greet description"] = "... bei denen das Addon automatisch grüßen & verabschieden soll",
	["group types to greet premade description"] = "Gruppen die einfach durch einladen von Leuten zusammengestellt werden",

	LFR = "Schlachtzugbrowser",

	["misc settings hl"] = "Verschiedene Einstellungen",

	["greet joining player with name"] = "Spieler die der Gruppe beitreten mit Namen grüßen",
	["wait with greeting for joining player buzzword"] = "Mit dem grüßen eines beitretenden Spielers warten bis dieser seinerseits einen Gruß in den Chat schreibt.",
	["wait with greeting for joining player buzzword DESCRIPTION"] = "" .. 
		string.rep(" ", 9) .. "=> Um festzustellen, ob die Nachricht eines anderen Spielers ein Gruß ist,\n" .. 
		string.rep(" ", 14) .. "gleicht das Addon Chatnachrichten mit den von Dir konfigurierten Grußnachrichten (aller Sprachen) ab.\n" ..
		string.rep(" ", 14) .. "Wenn diese Checkbox deaktiviert wird, werden beitretende Spieler immer automatisch gegrüßt, unabhängig davon,\n" ..
		string.rep(" ", 14) .. "ob Sie selber gegrüßt haben oder nicht.",
	["greet joining player with name DESCRIPTION"] = "" ..
		string.rep(" ", 9) .. "=> Dabei wird zum aktuellen Stand des Addons einfach der Name des Spielers an deine Nachricht angehangen.",

	["options tab title lang independent strings"] = "Sprach-unabhängige Nachrichten",
	["lang independent greetings"] = "Sprach-unabhängige GRÜßE",
	["lang independent farewells"] = "Sprach-unabhängige VERABSCHIEDUNGEN",

	["info lang bound strings"] = "" ..
		"Die initialen voreingestellen Texte hier sind DUMMIES und hauptsächlich vor-festgelegt damit diese Options-Seite etwas selbsterklärender ist. " .. 
		"Da Diese Texte DUMMIES sind, sind sie in verschiedenen Fällen nicht besonders sinnig und bedürfen einer Anpassung durch Dich. " ..
		"Die Addon-seitige Festlegung dieser Dummies für alle verfügbare Client Sprachen ist viel arbeit, daher ist eine sinnvolle Übersetzung je Sprache erstmal hinten angestellt, wird aber vermutlich in Zukunft kommen.",

	["options tab title lang bound strings"] = "Nachrichten (je Sprache)",

	["wait until all connected"] = "Mit dem Grüßen warten, bis alle Spieler mit dem Insatanz-Server verbunden sind",
	["wait time after join"] = "Wie lange soll nach betreten des Dungeons bzw nachdem alle Spieler verbunden sind gewartet werden bis der Gruß gepostet wird?",
	["congratulate players on level up"] = "Spielern gratuliert, wenn sie ein Level-Up haben",

	["lfd tab description"] = "Diese Einstellung beziehen sich auf die Gruppen-Art >Dungeonbrowser<.",

	["daytime dependent greetings"] = "Tageszeit-abhängige Grüße",
	["daytime dependent farewells"] = "Tageszeit-abhängige Verabschiedungen",

	["generally allow use of daytime independent texts"] = "Generell die Verwendung von Tageszeit-unabhängigen Texten erlauben",
	["generally allow use of daytime dependent texts"] = "Generell die Verwendung von Tageszeit-abhängigen Texten erlauben",

	--["options tab title en strings"] = "Englische Nachr.",

	clientLangs = {
		enUS = "Englisch",
		deDE = "Deutsch",
		frFR = "Französisch",
		koKR = "Koreanisch",
		zhCN = "Chinesisch (Vereinfacht) (zhCN)",
		zhTW = "Chinesisch (Traditionell) (zhTW)",
		esES = "Spanisch (Spanien) (esES)",
		esMX = "Spanisch (Mexiko) (esMX)",
		ruRU = "Russisch",
		ptBR = "Portugiesisch (Brasilien)",
		itIT = "Italienisch"
	},

	daytimes = {
		morning = "morgens",
		afternoon = "nachmittags", 
		evening = "abends", 
		night = "nachts", 
		midday = "mittags"
	},

	groups = "Gruppen",

	greetings = "Grüße",
	farewells = "Verabschiedungen",

	["error must be a number"] = "Das muss eine Zahl sein.",

	["in minutes"] = "in Minuten",
	["in seconds"] = "in Sekunden",
	["minutes"] = "Minuten",
	["seconds"] = "Sekunden",

}