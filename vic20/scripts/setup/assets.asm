
* = $1C00 "Charset"
	CHAR_SET:
		.import binary "../assets/char.bin"   //roll 12!

	* = $4000 "Screen data"

	CHAR_COLORS:
		.import binary "../assets/colours.bin"

	MAP_TILES:
		.import binary "../assets/tiles.bin"

	MAP:
		.import binary "../assets/map.bin"

	TITLE_CHAR_COLORS:
		.import binary "../assets/title_colours.bin"

	TITLE_MAP_TILES:
		.import binary "../assets/title_tiles.bin"

	TITLE_MAP:
		.import binary "../assets/title_map.bin"



		* = $1400 "Title Charset"
	TITLE_CHAR_SET:
		.import binary "../assets/title_char.bin"   //roll 12!
