
#include "BuildBlock.as"

const string blocks_property = "blocks";
const string inventory_offset = "inventory offset";

const u16[] bTiles = {
		/*water*/ 0,
		/*road*/ 384,
		/*roadtograss*/ 400,
		/*roadtograss_1*/ 401,
		/*roadtograss_2*/ 402,
		/*roadtograss_3*/ 403,
		/*roadtograss_4*/ 404,
		/*roadtograss_5*/ 405,
		/*roadtograss_6*/ 406,
		/*roadtograss_7*/ 407,
		/*roadtosand*/ 416,
		/*roadtosand_1*/ 417,
		/*roadtosand_2*/ 418,
		/*roadtosand_3*/ 419,
		/*roadtosand_4*/ 420,
		/*roadtosand_5*/ 421,
		/*roadtosand_6*/ 422,
		/*roadtosand_7*/ 423,
		/*roadtodirt*/ 432,
		/*roadtodirt_1*/ 433,
		/*roadtodirt_2*/ 434,
		/*roadtodirt_3*/ 435,
		/*roadtodirt_4*/ 436,
		/*roadtodirt_5*/ 437,
		/*roadtodirt_6*/ 438,
		/*roadtodirt_7*/ 439,
		/*roadtowater*/ 464,
		/*roadtowater_1*/ 465,
		/*roadtowater_2*/ 466,
		/*roadtowater_3*/ 467,
		/*roadtowater_4*/ 468,
		/*roadtowater_5*/ 469,
		/*roadtowater_6*/ 470,
		/*roadtowater_7*/ 471,
		/*grass*/ 388,
		/*grasstosand*/ 408,
		/*grasstosand_1*/ 409,
		/*grasstosand_2*/ 410,
		/*grasstosand_3*/ 411,
		/*grasstosand_4*/ 412,
		/*grasstosand_5*/ 413,
		/*grasstosand_6*/ 414,
		/*grasstosand_7*/ 415,
		/*grasstodirt*/ 424,
		/*grasstodirt_1*/ 425,
		/*grasstodirt_2*/ 426,
		/*grasstodirt_3*/ 427,
		/*grasstodirt_4*/ 426,
		/*grasstodirt_5*/ 429,
		/*grasstodirt_6*/ 430,
		/*grasstodirt_7*/ 431,
		/*grasstowater*/ 448,
		/*grasstowater_1*/ 449,
		/*grasstowater_2*/ 450,
		/*grasstowater_3*/ 451,
		/*grasstowater_4*/ 452,
		/*grasstowater_5*/ 453,
		/*grasstowater_6*/ 454,
		/*grasstowater_7*/ 455,
		/*sand*/ 392,
		/*sandtodirt*/ 440,
		/*sandtodirt_1*/ 441,
		/*sandtodirt_2*/ 442,
		/*sandtodirt_3*/ 443,
		/*sandtodirt_4*/ 444,
		/*sandtodirt_5*/ 445,
		/*sandtodirt_6*/ 446,
		/*sandtodirt_7*/ 447,
		/*sandtowater*/ 456,
		/*sandtowater_1*/ 457,
		/*sandtowater_2*/ 458,
		/*sandtowater_3*/ 459,
		/*sandtowater_4*/ 460,
		/*sandtowater_5*/ 461,
		/*sandtowater_6*/ 462,
		/*sandtowater_7*/ 463,
		/*dirt*/ 396,
		/*dirttowater*/ 472,
		/*dirttowater_1*/ 473,
		/*dirttowater_2*/ 474,
		/*dirttowater_3*/ 475,
		/*dirttowater_4*/ 476,
		/*dirttowater_5*/ 477,
		/*dirttowater_6*/ 478,
		/*dirttowater_7*/ 479,
		/*checkers*/ 560,
		/*checkers_1*/ 561,
		/*checkers_2*/ 562,
		/*checkers_3*/ 563,
		/*rumbler*/ 544,
		/*rumbler_1*/ 545,
		/*rumbler_2*/ 546,
		/*rumbler_3*/ 547,
		/*rumblertograss*/ 480,
		/*rumblertograss_1*/ 481,
		/*rumblertograss_2*/ 482,
		/*rumblertograss_3*/ 483,
		/*rumblertograss_4*/ 484,
		/*rumblertograss_5*/ 485,
		/*rumblertograss_6*/ 486,
		/*rumblertograss_7*/ 487,
		/*rumblertograss_8*/ 488,
		/*rumblertograss_9*/ 489,
		/*rumblertograss_10*/ 490,
		/*rumblertograss_11*/ 491,
		/*rumblertograss_12*/ 492,
		/*rumblertograss_13*/ 493,
		/*rumblertograss_14*/ 494,
		/*rumblertoroad*/ 496,
		/*rumblertoroad_1*/ 497,
		/*rumblertoroad_2*/ 498,
		/*rumblertoroad_3*/ 499,
		/*rumblertoroad_4*/ 500,
		/*rumblertoroad_5*/ 501,
		/*rumblertoroad_6*/ 502,
		/*rumblertoroad_7*/ 503,
		/*rumblertoroad_8*/ 504,
		/*rumblertoroad_9*/ 505,
		/*rumblertoroad_10*/ 506,
		/*rumblertoroad_11*/ 507,
		/*rumblertoroad_12*/ 508,
		/*rumblertoroad_13*/ 510,
		/*rumblertoroad_14*/ 511,
		/*rumblertosand =*/ 513,
		/*rumblertosand_1 =*/ 514,
		/*rumblertosand_2 =*/ 515,
		/*rumblertosand_3 =*/ 516,
		/*rumblertosand_4 =*/ 517,
		/*rumblertosand_5 =*/ 518,
		/*rumblertosand_6 =*/ 519,
		/*rumblertosand_7 =*/ 520,
		/*rumblertosand_8 =*/ 521,
		/*rumblertosand_9 =*/ 522,
		/*rumblertosand_10 =*/ 523,
		/*rumblertosand_11 =*/ 524,
		/*rumblertosand_12 =*/ 525,
		/*rumblertosand_13 =*/ 526,
		/*rumblertosand_14 =*/ 527,
		/*rumblertodirt =*/ 529,
		/*rumblertodirt_1 =*/ 530,
		/*rumblertodirt_2 =*/ 531,
		/*rumblertodirt_3 =*/ 532,
		/*rumblertodirt_4 =*/ 533,
		/*rumblertodirt_5 =*/ 534,
		/*rumblertodirt_6 =*/ 535,
		/*rumblertodirt_7 =*/ 536,
		/*rumblertodirt_8 =*/ 537,
		/*rumblertodirt_9 =*/ 538,
		/*rumblertodirt_10 =*/ 539,
		/*rumblertodirt_11 =*/ 540,
		/*rumblertodirt_12 =*/ 541,
		/*rumblertodirt_13 =*/ 542,
		/*rumblertodirt_14 =*/ 543,
		/*skimarksroad_1*/ 495,
		/*skimarksroad_2*/ 511,
		/*skimarksroad_3 =*/ 527,
		/*skimarksroad_4 =*/ 543,
		/*skimarksroad_5 =*/ 559,
		/*skimarksroad_6 =*/ 575,
		/*fence_gate*/ 564,
		/*fence_corner*/ 548,
		/*fence_grass*/ 549,
		/*fence_sand*/ 550,
		/*fence_dirt*/ 551,
		/*fence_water*/ 552,
		/*crop_red*/ 553,
		/*crop_green*/ 556,
		/*crop_empty*/ 565,
		/*crop_empty_grassy*/ 567,
		/*crop_empty_water*/ 568,
		/*crop_blue*/ 569,
		/*crop_yellow*/ 572,
		/*woodlogs*/ 576,
		/*woodlogs_1*/ 577,
		/*woodbrick*/ 578,
		/*woodpath_1*/ 579,
		/*woodpath_2*/ 580,
		/*woodpath_3*/ 581,
		/*woodpath_4*/ 582,
		/*woodpath_5*/ 583,
		/*woodpath_corner_1*/ 584,
		/*woodpath_corner_2*/ 585,
		/*woodpath_corner_3*/ 586,
		/*woodpath_corner_3*/ 587,
		/*flowers_1*/ 588,
		/*flowers_2*/ 589,
		/*flowers_3*/ 590,
		/*flowers_4*/ 591,
		/*flowers_5*/ 604,
		/*flowers_6*/ 605,
		/*flowers_7*/ 606,
		/*flowers_8*/ 607,
		/*dirtwall*/ 592,
		/*dirtwall_1*/ 593,
		/*dirtwall_2*/ 594,
		/*dirtwall_3*/ 595,
		/*dirtwall_4*/ 596,
		/*dirtwall_5*/ 597,	
		/*dirtwall_6*/ 598,
		/*dirtwall_7*/ 599,
		/*dirtwall_8*/ 600,
		/*dirtwall_9*/ 601,
		/*woodlogs2_1*/ 602,
		/*woodlogs2_2*/ 603,
		/*stonewall*/ 608,
		/*stonewall_1*/ 609,
		/*stonewall_2*/ 610,
		/*stonewall_3*/ 611,
		/*stonewall_4*/ 612,
		/*stonewall_5*/ 613,
		/*stonewall_6*/ 614,
		/*stonewall_7*/ 615,
		/*stonewall_8*/ 616,
		/*stonewall_9*/ 617,
		/*stonething_1*/ 618,
		/*stonething_2*/ 619,
		/*rooftile_1*/ 620,
		/*rooftile_2*/ 621,
		/*mudtrack_1*/ 622,
		/*mudtrack_2*/ 623,
		/*traintracks_1*/ 624,
		/*traintracks_2*/ 625,
		/*traintracks_3*/ 626,
		/*traintracks_4*/ 627,
		/*traintracks_5*/ 628,
		/*extabrick_1*/ 629,
		/*extabrick_2*/ 630,
		/*extabrick_3*/ 631,
		/*extabrick_4*/ 632,
		/*extabrick_5*/ 633,
		/*extabrick_6*/ 634,
		/*extabrick_7*/ 635,
		/*extabrick_8*/ 636,
		/*cobblestone_1*/ 637,
		/*cobblestone_2*/ 638,
		/*cobblestone_3*/ 639,
		/*roof1_1*/ 640,
		/*roof1_2*/ 641,
		/*roof1_3*/ 642,
		/*roof1_4*/ 643,
		/*roof1_5*/ 644,
		/*roof1_6*/ 645,
		/*roof1_7*/ 646,
		/*roof1_8*/ 647,
		/*roof1_9*/ 648,
		/*roof1_10*/ 649,
		/*roof1_11*/ 650,
		/*roof1_12*/ 651,
		/*roof1_13*/ 652,
		/*roof1_14*/ 653,
		/*roof1_15*/ 654,
		/*roof1_16*/ 655,

		/*roof2_1*/ 656,
		/*roof2_2*/ 657,
		/*roof2_3*/ 658,
		/*roof2_4*/ 659,
		/*roof2_5*/ 660,
		/*roof2_6*/ 661,
		/*roof2_7*/ 662,
		/*roof2_8*/ 663,
		/*roof2_9*/ 664,
		/*roof2_10*/ 665,
		/*roof2_11*/ 666,
		/*roof2_12*/ 667,
		/*roof2_13*/ 668,
		/*roof2_14*/ 669,
		/*roof2_15*/ 670,
		/*roof2_16*/ 671,

		/*roof3_1*/ 672,
		/*roof3_2*/ 673,
		/*roof3_3*/ 674,
		/*roof3_4*/ 675,
		/*roof3_5*/ 676,
		/*roof3_6*/ 677,
		/*roof3_7*/ 678,
		/*roof3_8*/ 679,
		/*roof3_9*/ 680,
		/*roof3_10*/ 681,
		/*roof3_11*/ 682,
		/*roof3_12*/ 683,
		/*roof3_13*/ 684,
		/*roof3_14*/ 685,
		/*roof3_15*/ 686,
		/*roof3_16*/ 687,

		/*roof4_1*/ 688,
		/*roof4_2*/ 689,
		/*roof4_3*/ 690,
		/*roof4_4*/ 691,
		/*roof4_5*/ 692,
		/*roof4_6*/ 693,
		/*roof4_7*/ 694,
		/*roof4_8*/ 695,
		/*roof4_9*/ 696,
		/*roof4_10*/ 697,
		/*roof4_11*/ 698,
		/*roof4_12*/ 699,
		/*roof4_13*/ 700,
		/*roof4_14*/ 701,
		/*roof4_15*/ 702,
		/*roof4_16*/ 703,

		/*roof5_1 */ 704,
		/*roof5_2 */ 705,
		/*roof5_3 */ 706,
		/*roof5_4 */ 707,
		/*roof5_5 */ 708,
		/*roof5_6 */ 709,
		/*roof5_7 */ 710,
		/*roof5_8 */ 711,
		/*roof5_9 */ 712,
		/*roof5_10*/ 713,
		/*roof5_11*/ 714,
		/*roof5_12*/ 715,
		/*roof5_13*/ 716,
		/*roof5_14*/ 717,
		/*roof5_15*/ 718,
		/*roof5_16*/ 719,

		/*roof6_1 */ 720,
		/*roof6_2 */ 721,
		/*roof6_3 */ 722,
		/*roof6_4 */ 723,
		/*roof6_5 */ 724,
		/*roof6_6 */ 725,
		/*roof6_7 */ 726,
		/*roof6_8 */ 727,
		/*roof6_9 */ 728,
		/*roof6_10*/ 729,
		/*roof6_11*/ 730,
		/*roof6_12*/ 731,
		/*roof6_13*/ 732,
		/*roof6_14*/ 733,
		/*roof6_15*/ 734,
		/*roof6_16*/ 735,

		/*fence2_1 */ 736,
		/*fence2_2 */ 737,
		/*fence2_3 */ 738,
		/*fence2_4 */ 739,
		/*fence2_5 */ 740,
		/*fence2_6 */ 741,
		/*fence2_7 */ 742,
		/*fence2_8 */ 743,
		/*fence2_9 */ 744,
		/*fence2_10*/ 745,

		/*sand2_1*/ 746,
		/*sand2_2*/ 747,
		/*sand2_3*/ 748,
		/*dirt2_1*/ 749,
		/*dirt2_2*/ 750,
		/*dirt2_3*/ 751,

		 /*bushes_1 */ 752,
		 /*bushes_2 */ 753,
		 /*bushes_3 */ 754,
		 /*bushes_4 */ 755,
		 /*bushes_5*/ 756,
		 /*bushes_6*/ 757,
		 /*bushes_7 */ 758,
		 /*bushes_8*/ 759,
		 /*bushes_9*/ 760,
		 /*bushes_10 */ 761,
		 /*bushes_11*/ 762,
		 /*bushes_12*/ 763,
		 /*bushes_13*/ 764,
		 /*bushes_14*/ 765,
		 /*bushes_15*/ 766,
		 /*bushes_16*/ 767,

		 /*roadmarkings_1*/ 784,
		 /*roadmarkings_2*/ 785,
		 /*roadmarkings_3*/ 786,
		 /*roadmarkings_4*/ 787,
		 /*roadmarkings_5*/ 788,
		 /*roadmarkings_6*/ 789,
		 /*roadmarkings_7*/ 790,
		 /*roadmarkings_8*/ 791,

		 /*grassonsand_6*/ 792,
		 /*grassonsand_6*/ 793,
		 /*dirtonsand_6*/  794,
		 /*dirtonsand_6*/  795,
		 /*grassondirt_6*/ 796,
		 /*grassondirt_6*/ 797,
		 /*sandondirt_6*/  798,
		 /*sandondirt_6*/  799,

		 /*grassonsand_6*/ 800,
		 /*grassonsand_6*/ 801,
		 /*dirtonsand_6*/  802,
		 /*dirtonsand_6*/  803,
		 /*grassondirt_6*/ 804,
		 /*grassondirt_6*/ 805,
		 /*sandondirt_6*/  806,
		 /*sandondirt_6*/  807,

		 /*grassonsand_6*/ 808,
		 /*grassonsand_6*/ 809,
		 /*dirtonsand_6*/  810,
		 /*dirtonsand_6*/  811,
		 /*grassondirt_6*/ 812,
		 /*grassondirt_6*/ 813,
		 /*sandondirt_6*/  814,
		 /*sandondirt_6*/  815,

		 /*grassonsand_6*/ 816,
		 /*grassonsand_6*/ 817,
		 /*dirtonsand_6*/  818,
		 /*dirtonsand_6*/  819,
		 /*grassondirt_6*/ 820,
		 /*grassondirt_6*/ 821,
		 /*sandondirt_6*/  822,
		 /*sandondirt_6*/  823,

		 /*grassonsand_6*/ 824,
		 /*grassonsand_6*/ 825,
		 /*dirtonsand_6*/  826,
		 /*dirtonsand_6*/  827,
		 /*grassondirt_6*/ 828,
		 /*grassondirt_6*/ 829,
		 /*sandondirt_6*/  830,
		 /*sandondirt_6*/  831,

		 /*grassonsand_6*/ 832,
		 /*grassonsand_6*/ 833,
		 /*dirtonsand_6*/  834,
		 /*dirtonsand_6*/  835,
		 /*grassondirt_6*/ 836,
		 /*grassondirt_6*/ 837,
		 /*sandondirt_6*/  838,
		 /*sandondirt_6*/  839,

		 /*grassonsand_6*/ 840,
		 /*grassonsand_6*/ 841,
		 /*dirtonsand_6*/  842,
		 /*dirtonsand_6*/  843,
		 /*grassondirt_6*/ 844,
		 /*grassondirt_6*/ 845,
		 /*sandondirt_6*/  846,
		 /*sandondirt_6*/  847,
		 /*sandondirt_6*/  848,
		 /*sandondirt_6*/  849,

		 /*grassonsand_6*/ 850,
		 /*grassonsand_6*/ 851,
		 /*dirtonsand_6*/  852,
		 /*dirtonsand_6*/  853,
		 /*grassondirt_6*/ 854,
		 /*grassondirt_6*/ 855,
		 /*sandondirt_6*/  856,
		 /*sandondirt_6*/  857,
		 /*sandondirt_6*/  858,
		 /*sandondirt_6*/  859,

		 /*grassonsand_6*/ 860,
		 /*grassonsand_6*/ 861,
		 /*dirtonsand_6*/  862,
		 /*dirtonsand_6*/  863,
		 /*grassondirt_6*/ 864,
		 /*grassondirt_6*/ 865,
		 /*sandondirt_6*/  866,
		 /*sandondirt_6*/  867,
		 /*sandondirt_6*/  868,
		 /*sandondirt_6*/  869,

		 /*grassonsand_6*/ 870,
		 /*grassonsand_6*/ 871,
		 /*dirtonsand_6*/  872,
		 /*dirtonsand_6*/  873,
		 /*grassondirt_6*/ 874,
		 /*grassondirt_6*/ 875,
		 /*sandondirt_6*/  876,
		 /*sandondirt_6*/  877,
		 /*sandondirt_6*/  878,
		 /*sandondirt_6*/  879,

		 /*grassonsand_6*/ 880,
		 /*grassonsand_6*/ 881,
		 /*dirtonsand_6*/  882,
		 /*dirtonsand_6*/  883,
		 /*grassondirt_6*/ 884,
		 /*grassondirt_6*/ 885,
		 /*sandondirt_6*/  886,
		 /*sandondirt_6*/  887,
		 /*sandondirt_6*/  888,
		 /*sandondirt_6*/  889,

		 /*grassonsand_6*/ 890,
		 /*grassonsand_6*/ 891,
		 /*dirtonsand_6*/  892,
		 /*dirtonsand_6*/  893,
		 /*grassondirt_6*/ 894,
		 /*grassondirt_6*/ 895

};

const string[] blobNames =
{       
	"dirtwalltiny",
	"dirtwallsmall",
	"dirtwallmedium",
	"dirtwallbig",
	"stonewalltiny",
	"stonewallsmall",
	"stonewallmedium",
	"stonewallbig",
	"woodfencetiny",
	"woodfencesmall",
	"woodfencemedium",
	"woodfencebig",
	"stonefencetiny",
	"stonefencesmall",
	"stonefencemedium",
	"stonefencebig",
	"haybale",
	"haybalebig",
	"palmtree",
	"bigtree1",
	"bigtree3",
	"smalltreetrunk",
	"bigtreetrunk",
	"boulder1",
	"boulder2",
	"boulder3",
	"boulder4",
	"boulder5",
	"boulder6",
	"boulder7",
	"boulder8",
	"waterbarrel",
	"excavator",
	"propkar",
	"propboat",
	"propplane",
	"brickwalltiny",
	"brickwallsmall",
	"brickwallmedium",
	"brickwallbig",
	"person",
	"crowd_l",
	"cone",
	"roadoverpass",
	"watertowerround",
	"watertowersquare",
	"finishline_s",
	"finishline_m",
	"finishline_l",
	"finishline_xl",
	"dirtcorner_s",
	"dirtcorner_m",
	"dirtcorner_l",
	"stonecorner_s",
	"stonecorner_m",
	"stonecorner_l",
	"waterbarrel_s",
	"haybaleround",
	//"blinkinglight",
	"overbarsbase",
	"overbarsbar",
	"overbarsbar_big",
	"crowd_s",
	"crowd_m",
	"flag_s",

	"spawnmarkblob",
	"waymarkblob"
};

void addMenuItems(BuildBlock[][]@ blocks)
{
	blocks.set_length(2); //2 pages

	for (u16 i = 0; i < bTiles.length; i++)
	{
		u16 tile = bTiles[i];
		BuildBlock b(tile, "", "$tile_"+i+"$", "{Insert Tile Name}");
		blocks[0].push_back(b);
	}	
	//for (u16 i = 0; i < blobNames.length; i++)
	//{
	//	string name = blobNames[i];
	//	BuildBlock b(0, name, "$"+name+"$", name);
	//	blocks[1].push_back(b);
	//}
	{
		AddIconToken("$dirtwalltiny$", "WallBlobs.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "dirtwalltiny", "$dirtwalltiny$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$dirtwallsmall$", "WallBlobs.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "dirtwallsmall", "$dirtwallsmall$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$dirtwallmedium$", "WallBlobs.png", Vec2f(16, 8), 0);
		BuildBlock b(0, "dirtwallmedium", "$dirtwallmedium$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$dirtwallbig$", "WallBlobs.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "dirtwallbig", "$dirtwallbig$", "WallBlobs");
		blocks[1].push_back(b);
	}	
	{
		AddIconToken("$stonewalltiny$", "StoneWall.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "stonewalltiny", "$stonewalltiny$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonewallsmall$", "StoneWall.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "stonewallsmall", "$stonewallsmall$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonewallmedium$", "StoneWall.png", Vec2f(16, 8), 0);
		BuildBlock b(0, "stonewallmedium", "$stonewallmedium$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonewallbig$", "StoneWall.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "stonewallbig", "$stonewallbig$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$woodfencetiny$", "WoodFence.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "woodfencetiny", "$woodfencetiny$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$woodfencesmall$", "WoodFence.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "woodfencesmall", "$woodfencesmall$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$woodfencemedium$", "WoodFence.png", Vec2f(16, 8), 0);
		BuildBlock b(0, "woodfencemedium", "$stonefencemedium$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$woodfencebig$", "WoodFence.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "woodfencebig", "$woodfencebig$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonefencetiny$", "StoneFence.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "stonefencetiny", "$stonefencetiny$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonefencesmall$", "StoneFence.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "stonefencesmall", "$stonefencesmall$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonefencemedium$", "StoneFence.png", Vec2f(16, 8), 0);
		BuildBlock b(0, "stonefencemedium", "$stonefencemedium$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$stonefencebig$", "StoneFence.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "stonefencebig", "$stonefencebig$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$haybale$", "Haybales.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "haybale", "$haybale$", "Haybales");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$haybalebig$", "Haybales.png", Vec2f(16, 16), 1);
		BuildBlock b(0, "haybalebig", "$haybalebig$", "Haybales");
		blocks[1].push_back(b);
	}
	{		
		AddIconToken("$palmtree$", "TreeIcons.png", Vec2f(16, 16), 0);
		BuildBlock b(0, "palmtree", "$palmtree$", "Trees");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$bigtree1$", "TreeIcons.png", Vec2f(16, 16), 3);
		BuildBlock b(0, "bigtree1", "$bigtree1$", "Trees");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$bigtree3$", "TreeIcons.png", Vec2f(16, 16), 3);
		BuildBlock b(0, "bigtree3", "$bigtree3$", "Trees");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$samlltreetrunk$", "Trees.png", Vec2f(8, 8), 1);
		BuildBlock b(0, "samlltreetrunk", "$samlltreetrunk$", "TreeTrunk");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$bigtreetrunk$", "Trees.png", Vec2f(16, 16), 1);
		BuildBlock b(0, "bigtreetrunk", "$bigtreetrunk$", "TreeTrunk");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder1$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder1", "$boulder1$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder2$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder2", "$boulder2$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder3$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder3", "$boulder3$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder4$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder4", "$boulder4$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder5$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder5", "$boulder5$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder6$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder6", "$boulder6$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder7$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder7", "$boulder7$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$boulder8$", "Boulders.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "boulder8", "$boulder8$", "Boulder");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$waterbarrel$", "WaterBarrel.png", Vec2f(16, 16), 0);
		BuildBlock b(0, "waterbarrel", "$waterbarrel$", "WaterBarrel");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$excavator$", "Excavator.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "excavator", "$excavator$", "Excavator");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$propkar$", "Kar.png", Vec2f(16, 24), 1);
		BuildBlock b(0, "propkar", "$propkar$", "PropKar");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$propboat$", "Boats.png", Vec2f(16, 24), 1);
		BuildBlock b(0, "propboat", "$propboat$", "PropBoat");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$propplane$", "PropPlane.png", Vec2f(64, 48), 0);
		BuildBlock b(0, "propplane", "$propplane$", "PropPlane");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$brickwalltiny$", "BrickWall.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "brickwalltiny", "$brickwalltiny$", "Brick Wall T");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$brickwallsmall$", "BrickWall.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "brickwallsmall", "$brickwallsmall$", "Brick Wall S");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$brickwallmedium$", "BrickWall.png", Vec2f(16, 8), 0);
		BuildBlock b(0, "brickwallmedium", "$brickwallmedium$", "Brick Wall M");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$brickwallbig$", "BrickWall.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "brickwallbig", "$brickwallbig$", "Brick Wall L");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$person$", "Crowd.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "person", "$person$", "person");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$Crowd_l$", "Crowd.png", Vec2f(16, 16), 0);
		BuildBlock b(0, "Crowd_l", "$Crowd_l$", "Crowd_l");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$tcone$", "TrafficCone.png", Vec2f(8, 8), 1);
		BuildBlock b(0, "tcone", "$tcone$", "Excavator");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$overpass$", "RoadOverpass.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "overpass", "$overpass$", "Road Overpass");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$watertowerround$", "WaterTowers.png", Vec2f(32, 32), 0);
		BuildBlock b(0, "watertowerround", "$watertowerround$", "watertowerround");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$watertowersquare$", "WaterTowers.png", Vec2f(32, 32), 1);
		BuildBlock b(0, "watertowersquare", "$watertowersquare$", "watertowersquare");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$finishline_s$", "FinishLine.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "finishline_s", "$finishline_s$", "finishline_s");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$finishline_m$", "FinishLine.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "finishline_m", "$finishline_m$", "finishline_m");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$finishline_l$", "FinishLine.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "finishline_l", "$finishline_l$", "finishline_l");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$finishline_xl$", "FinishLine.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "finishline_xl", "$finishline_xl$", "finishline_xl");
		blocks[1].push_back(b);
	}	
	{
		AddIconToken("$dirtcorner_s$", "DirtCorners.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "dirtcorner_s", "$dirtcorner_s$", "WallBlobs");
		blocks[1].push_back(b);
	}			
	{
		AddIconToken("$dirtcorner_m$", "DirtCorners.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "dirtcorner_m", "$dirtcorner_m$", "WallBlobs");
		blocks[1].push_back(b);
	}		
	{
		AddIconToken("$dirtcorner_l$", "DirtCorners.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "dirtcorner_l", "$dirtcorner_l$", "WallBlobs");
		blocks[1].push_back(b);
	}	
	{
		AddIconToken("$stonecorner_s$", "StoneCorners.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "stonecorner_s", "$stonecorner_s$", "WallBlobs");
		blocks[1].push_back(b);
	}		
	{
		AddIconToken("$stonecorner_m$", "StoneCorners.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "stonecorner_m", "$stonecorner_m$", "WallBlobs");
		blocks[1].push_back(b);
	}		
	{
		AddIconToken("$stonecorner_l$", "StoneCorners.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "stonecorner_l", "$stonecorner_l$", "WallBlobs");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$waterbarrel_s$", "WaterBarrel.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "waterbarrel_s", "$waterbarrel_s$", "waterbarrel_s");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$haybaleround$", "Haybales.png", Vec2f(8, 8), 0);
		BuildBlock b(0, "haybaleround", "$haybaleround$", "Haybales");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$overbarsbase$", "OverBars.png", Vec2f(8, 8), 4);
		BuildBlock b(0, "overbarsbase", "$overbarsbase$", "overbarsbase");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$overbarsbar$", "OverBars.png", Vec2f(16, 8), 0);
		BuildBlock b(0, "overbarsbar", "$overbarsbar$", "overbarsbar");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$overbarsbar_big$", "OverBars.png", Vec2f(24, 8), 0);
		BuildBlock b(0, "overbarsbar_big", "$overbarsbar_big$", "overbarsbar_big");
		blocks[1].push_back(b);
	}


	{
		AddIconToken("$crowd_s$", "Crowd.png", Vec2f(16, 16), 0);
		BuildBlock b(0, "crowd_s", "$crowd_s$", "crowd_s");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$crowd_m$", "Crowd.png", Vec2f(16, 16), 0);
		BuildBlock b(0, "crowd_m", "$crowd_m$", "crowd_m");
		blocks[1].push_back(b);
	}	
	{
		AddIconToken("$flag_s$", "Crowd.png", Vec2f(16, 4), 0);
		BuildBlock b(0, "flag_s", "$flag_s$", "flag_s");
		blocks[1].push_back(b);
	}

	//{
	//	AddIconToken("$blinkinglight$", "BlinkingLight.png", Vec2f(8, 8), 0);
	//	BuildBlock b(0, "blinkinglight", "$blinkinglight$", "blinkinglight");
	//	blocks[1].push_back(b);
	//}
	{
		AddIconToken("$spawnmarkblob$", "Markers.png", Vec2f(16, 16), 1);
		BuildBlock b(0, "spawnmarkblob", "$spawnmarkblob$", "Markers");
		blocks[1].push_back(b);
	}
	{
		AddIconToken("$waymarkblob$", "Markers.png", Vec2f(16, 16), 0);
		BuildBlock b(0, "waymarkblob", "$waymarkblob$", "Markers");
		blocks[1].push_back(b);
	}
}
