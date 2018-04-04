`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/03 22:24:00
// Design Name: 
// Module Name: vram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "globalConstants.v"

module vram(
    input wire         in_clock,
    input wire         in_reset,
    input wire         in_enable,
    input wire [7:0]   in_updateXPos,
    input wire [7:0]   in_updateYPos,
    input wire [7:0]   in_updateCharAscii,
    input wire         in_update,
    input wire [7:0]   in_charXPos,
    input wire [7:0]   in_charYPos,
    output reg [0:127] out_bitmap = 128'd0);
    
    // Memory for saving all the characters.
    // 80 x 30
    reg [7:0] displayAsciiMaps [0:79][0:29];
    reg [7:0] i = 8'd0, j = 8'd0, currentAscii = 8'd0;
    wire [0:127] fontResult;
    
    initial begin
        // Reset the maps.
        for(i = 8'd0; i < 8'd80; i = i+1) begin
            for(j = 8'd0; j < 8'd30; j = j+1) begin
                // Reset the map.
                displayAsciiMaps[i][j] = 8'd0;
            end
        end
        displayAsciiMaps[0][0] = `ASC_CHAR_A;
        displayAsciiMaps[0][1] = `ASC_CHAR_B;
        displayAsciiMaps[0][2] = `ASC_CHAR_C;
        displayAsciiMaps[0][3] = `ASC_CHAR_D;
        displayAsciiMaps[0][4] = `ASC_CHAR_E;
        displayAsciiMaps[0][5] = `ASC_CHAR_F;
        displayAsciiMaps[0][6] = `ASC_CHAR_G;
    end
    
    always @(posedge in_clock) begin
        if (in_reset) begin
            // Reset the output.
            out_bitmap <= 128'd0;
            // Reset the cache.
            currentAscii <= 8'd0;
        end else begin
            if (in_enable) begin
                // Check char update.
                if (in_update) begin
                    // Apply the character update.
                    displayAsciiMaps[in_updateXPos][in_updateYPos] <= in_updateCharAscii;
                end
                case (displayAsciiMaps[in_charXPos][in_charYPos])
                    0  : out_bitmap = 128'h00000000000000000000000000000000;
                    1  : out_bitmap = 128'h00007E81A58181BD9981817E00000000;
                    2  : out_bitmap = 128'h00007EFFDBFFFFC3E7FFFF7E00000000;
                    3  : out_bitmap = 128'h000000006CFEFEFEFE7C381000000000;
                    4  : out_bitmap = 128'h0000000010387CFE7C38100000000000;
                    5  : out_bitmap = 128'h000000183C3CE7E7E718183C00000000;
                    6  : out_bitmap = 128'h000000183C7EFFFF7E18183C00000000;
                    7  : out_bitmap = 128'h000000000000183C3C18000000000000;
                    8  : out_bitmap = 128'hFFFFFFFFFFFFE7C3C3E7FFFFFFFFFFFF;
                    9  : out_bitmap = 128'h00000000003C664242663C0000000000;
                    10 : out_bitmap = 128'hFFFFFFFFFFC399BDBD99C3FFFFFFFFFF;
                    11 : out_bitmap = 128'h00001E0E1A3278CCCCCCCC7800000000;
                    12 : out_bitmap = 128'h00003C666666663C187E181800000000;
                    13 : out_bitmap = 128'h00003F333F3030303070F0E000000000;
                    14 : out_bitmap = 128'h00007F637F6363636367E7E6C0000000;
                    15 : out_bitmap = 128'h0000001818DB3CE73CDB181800000000;
                    16 : out_bitmap = 128'h0080C0E0F0F8FEF8F0E0C08000000000;
                    17 : out_bitmap = 128'h0002060E1E3EFE3E1E0E060200000000;
                    18 : out_bitmap = 128'h0000183C7E1818187E3C180000000000;
                    19 : out_bitmap = 128'h00006666666666666600666600000000;
                    20 : out_bitmap = 128'h00007FDBDBDB7B1B1B1B1B1B00000000;
                    21 : out_bitmap = 128'h007CC660386CC6C66C380CC67C000000;
                    22 : out_bitmap = 128'h0000000000000000FEFEFEFE00000000;
                    23 : out_bitmap = 128'h0000183C7E1818187E3C187E00000000;
                    24 : out_bitmap = 128'h0000183C7E1818181818181800000000;
                    25 : out_bitmap = 128'h0000181818181818187E3C1800000000;
                    26 : out_bitmap = 128'h0000000000180CFE0C18000000000000;
                    27 : out_bitmap = 128'h00000000003060FE6030000000000000;
                    28 : out_bitmap = 128'h000000000000C0C0C0FE000000000000;
                    29 : out_bitmap = 128'h0000000000286CFE6C28000000000000;
                    30 : out_bitmap = 128'h000000001038387C7CFEFE0000000000;
                    31 : out_bitmap = 128'h00000000FEFE7C7C3838100000000000;
                    32 : out_bitmap = 128'h00000000000000000000000000000000;
                    33 : out_bitmap = 128'h0000183C3C3C18181800181800000000;
                    34 : out_bitmap = 128'h00666666240000000000000000000000;
                    35 : out_bitmap = 128'h0000006C6CFE6C6C6CFE6C6C00000000;
                    36 : out_bitmap = 128'h18187CC6C2C07C060686C67C18180000;
                    37 : out_bitmap = 128'h00000000C2C60C183060C68600000000;
                    38 : out_bitmap = 128'h0000386C6C3876DCCCCCCC7600000000;
                    39 : out_bitmap = 128'h00303030600000000000000000000000;
                    40 : out_bitmap = 128'h00000C18303030303030180C00000000;
                    41 : out_bitmap = 128'h000030180C0C0C0C0C0C183000000000;
                    42 : out_bitmap = 128'h0000000000663CFF3C66000000000000;
                    43 : out_bitmap = 128'h000000000018187E1818000000000000;
                    44 : out_bitmap = 128'h00000000000000000018181830000000;
                    45 : out_bitmap = 128'h00000000000000FE0000000000000000;
                    46 : out_bitmap = 128'h00000000000000000000181800000000;
                    47 : out_bitmap = 128'h0000000002060C183060C08000000000;
                    48 : out_bitmap = 128'h0000386CC6C6D6D6C6C66C3800000000;
                    49 : out_bitmap = 128'h00001838781818181818187E00000000;
                    50 : out_bitmap = 128'h00007CC6060C183060C0C6FE00000000;
                    51 : out_bitmap = 128'h00007CC606063C060606C67C00000000;
                    52 : out_bitmap = 128'h00000C1C3C6CCCFE0C0C0C1E00000000;
                    53 : out_bitmap = 128'h0000FEC0C0C0FC060606C67C00000000;
                    54 : out_bitmap = 128'h00003860C0C0FCC6C6C6C67C00000000;
                    55 : out_bitmap = 128'h0000FEC606060C183030303000000000;
                    56 : out_bitmap = 128'h00007CC6C6C67CC6C6C6C67C00000000;
                    57 : out_bitmap = 128'h00007CC6C6C67E0606060C7800000000;
                    58 : out_bitmap = 128'h00000000181800000018180000000000;
                    59 : out_bitmap = 128'h00000000181800000018183000000000;
                    60 : out_bitmap = 128'h000000060C18306030180C0600000000;
                    61 : out_bitmap = 128'h00000000007E00007E00000000000000;
                    62 : out_bitmap = 128'h0000006030180C060C18306000000000;
                    63 : out_bitmap = 128'h00007CC6C60C18181800181800000000;
                    64 : out_bitmap = 128'h0000007CC6C6DEDEDEDCC07C00000000;
                    65 : out_bitmap = 128'h000010386CC6C6FEC6C6C6C600000000;
                    66 : out_bitmap = 128'h0000FC6666667C66666666FC00000000;
                    67 : out_bitmap = 128'h00003C66C2C0C0C0C0C2663C00000000;
                    68 : out_bitmap = 128'h0000F86C6666666666666CF800000000;
                    69 : out_bitmap = 128'h0000FE6662687868606266FE00000000;
                    70 : out_bitmap = 128'h0000FE6662687868606060F000000000;
                    71 : out_bitmap = 128'h00003C66C2C0C0DEC6C6663A00000000;
                    72 : out_bitmap = 128'h0000C6C6C6C6FEC6C6C6C6C600000000;
                    73 : out_bitmap = 128'h00003C18181818181818183C00000000;
                    74 : out_bitmap = 128'h00001E0C0C0C0C0CCCCCCC7800000000;
                    75 : out_bitmap = 128'h0000E666666C78786C6666E600000000;
                    76 : out_bitmap = 128'h0000F06060606060606266FE00000000;
                    77 : out_bitmap = 128'h0000C6EEFEFED6C6C6C6C6C600000000;
                    78 : out_bitmap = 128'h0000C6E6F6FEDECEC6C6C6C600000000;
                    79 : out_bitmap = 128'h00007CC6C6C6C6C6C6C6C67C00000000;
                    80 : out_bitmap = 128'h0000FC6666667C60606060F000000000;
                    81 : out_bitmap = 128'h00007CC6C6C6C6C6C6D6DE7C0C0E0000;
                    82 : out_bitmap = 128'h0000FC6666667C6C666666E600000000;
                    83 : out_bitmap = 128'h00007CC6C660380C06C6C67C00000000;
                    84 : out_bitmap = 128'h00007E7E5A1818181818183C00000000;
                    85 : out_bitmap = 128'h0000C6C6C6C6C6C6C6C6C67C00000000;
                    86 : out_bitmap = 128'h0000C6C6C6C6C6C6C66C381000000000;
                    87 : out_bitmap = 128'h0000C6C6C6C6D6D6D6FEEE6C00000000;
                    88 : out_bitmap = 128'h0000C6C66C7C38387C6CC6C600000000;
                    89 : out_bitmap = 128'h0000666666663C181818183C00000000;
                    90 : out_bitmap = 128'h0000FEC6860C183060C2C6FE00000000;
                    91 : out_bitmap = 128'h00003C30303030303030303C00000000;
                    92 : out_bitmap = 128'h00000080C0E070381C0E060200000000;
                    93 : out_bitmap = 128'h00003C0C0C0C0C0C0C0C0C3C00000000;
                    94 : out_bitmap = 128'h10386CC6000000000000000000000000;
                    95 : out_bitmap = 128'h00000000000000000000000000FF0000;
                    96 : out_bitmap = 128'h30301800000000000000000000000000;
                    97 : out_bitmap = 128'h0000000000780C7CCCCCCC7600000000;
                    98 : out_bitmap = 128'h0000E06060786C666666667C00000000;
                    99 : out_bitmap = 128'h00000000007CC6C0C0C0C67C00000000;
                    100: out_bitmap = 128'h00001C0C0C3C6CCCCCCCCC7600000000;
                    101: out_bitmap = 128'h00000000007CC6FEC0C0C67C00000000;
                    102: out_bitmap = 128'h0000386C6460F060606060F000000000;
                    103: out_bitmap = 128'h000000000076CCCCCCCCCC7C0CCC7800;
                    104: out_bitmap = 128'h0000E060606C7666666666E600000000;
                    105: out_bitmap = 128'h00001818003818181818183C00000000;
                    106: out_bitmap = 128'h00000606000E06060606060666663C00;
                    107: out_bitmap = 128'h0000E06060666C78786C66E600000000;
                    108: out_bitmap = 128'h00003818181818181818183C00000000;
                    109: out_bitmap = 128'h0000000000ECFED6D6D6D6C600000000;
                    110: out_bitmap = 128'h0000000000DC66666666666600000000;
                    111: out_bitmap = 128'h00000000007CC6C6C6C6C67C00000000;
                    112: out_bitmap = 128'h0000000000DC66666666667C6060F000;
                    113: out_bitmap = 128'h000000000076CCCCCCCCCC7C0C0C1E00;
                    114: out_bitmap = 128'h0000000000DC7666606060F000000000;
                    115: out_bitmap = 128'h00000000007CC660380CC67C00000000;
                    116: out_bitmap = 128'h0000103030FC30303030361C00000000;
                    117: out_bitmap = 128'h0000000000CCCCCCCCCCCC7600000000;
                    118: out_bitmap = 128'h000000000066666666663C1800000000;
                    119: out_bitmap = 128'h0000000000C6C6D6D6D6FE6C00000000;
                    120: out_bitmap = 128'h0000000000C66C3838386CC600000000;
                    121: out_bitmap = 128'h0000000000C6C6C6C6C6C67E060CF800;
                    122: out_bitmap = 128'h0000000000FECC183060C6FE00000000;
                    123: out_bitmap = 128'h00000E18181870181818180E00000000;
                    124: out_bitmap = 128'h00001818181800181818181800000000;
                    125: out_bitmap = 128'h0000701818180E181818187000000000;
                    126: out_bitmap = 128'h000076DC000000000000000000000000;
                    127: out_bitmap = 128'h0000000010386CC6C6C6FE0000000000;
                    128: out_bitmap = 128'h00003C66C2C0C0C0C2663C0C067C0000;
                    129: out_bitmap = 128'h0000CC0000CCCCCCCCCCCC7600000000;
                    130: out_bitmap = 128'h000C1830007CC6FEC0C0C67C00000000;
                    131: out_bitmap = 128'h0010386C00780C7CCCCCCC7600000000;
                    132: out_bitmap = 128'h0000CC0000780C7CCCCCCC7600000000;
                    133: out_bitmap = 128'h0060301800780C7CCCCCCC7600000000;
                    134: out_bitmap = 128'h00386C3800780C7CCCCCCC7600000000;
                    135: out_bitmap = 128'h000000003C666060663C0C063C000000;
                    136: out_bitmap = 128'h0010386C007CC6FEC0C0C67C00000000;
                    137: out_bitmap = 128'h0000C600007CC6FEC0C0C67C00000000;
                    138: out_bitmap = 128'h00603018007CC6FEC0C0C67C00000000;
                    139: out_bitmap = 128'h00006600003818181818183C00000000;
                    140: out_bitmap = 128'h00183C66003818181818183C00000000;
                    141: out_bitmap = 128'h00603018003818181818183C00000000;
                    142: out_bitmap = 128'h00C60010386CC6C6FEC6C6C600000000;
                    143: out_bitmap = 128'h386C3800386CC6C6FEC6C6C600000000;
                    144: out_bitmap = 128'h18306000FE66607C606066FE00000000;
                    145: out_bitmap = 128'h0000000000CC76367ED8D86E00000000;
                    146: out_bitmap = 128'h00003E6CCCCCFECCCCCCCCCE00000000;
                    147: out_bitmap = 128'h0010386C007CC6C6C6C6C67C00000000;
                    148: out_bitmap = 128'h0000C600007CC6C6C6C6C67C00000000;
                    149: out_bitmap = 128'h00603018007CC6C6C6C6C67C00000000;
                    150: out_bitmap = 128'h003078CC00CCCCCCCCCCCC7600000000;
                    151: out_bitmap = 128'h0060301800CCCCCCCCCCCC7600000000;
                    152: out_bitmap = 128'h0000C60000C6C6C6C6C6C67E060C7800;
                    153: out_bitmap = 128'h00C6007CC6C6C6C6C6C6C67C00000000;
                    154: out_bitmap = 128'h00C600C6C6C6C6C6C6C6C67C00000000;
                    155: out_bitmap = 128'h0018183C66606060663C181800000000;
                    156: out_bitmap = 128'h00386C6460F060606060E6FC00000000;
                    157: out_bitmap = 128'h000066663C187E187E18181800000000;
                    158: out_bitmap = 128'h00F8CCCCF8C4CCDECCCCCCC600000000;
                    159: out_bitmap = 128'h000E1B1818187E1818181818D8700000;
                    160: out_bitmap = 128'h0018306000780C7CCCCCCC7600000000;
                    161: out_bitmap = 128'h000C1830003818181818183C00000000;
                    162: out_bitmap = 128'h00183060007CC6C6C6C6C67C00000000;
                    163: out_bitmap = 128'h0018306000CCCCCCCCCCCC7600000000;
                    164: out_bitmap = 128'h000076DC00DC66666666666600000000;
                    165: out_bitmap = 128'h76DC00C6E6F6FEDECEC6C6C600000000;
                    166: out_bitmap = 128'h003C6C6C3E007E000000000000000000;
                    167: out_bitmap = 128'h00386C6C38007C000000000000000000;
                    168: out_bitmap = 128'h0000303000303060C0C6C67C00000000;
                    169: out_bitmap = 128'h000000000000FEC0C0C0C00000000000;
                    170: out_bitmap = 128'h000000000000FE060606060000000000;
                    171: out_bitmap = 128'h00C0C0C2C6CC183060DC860C183E0000;
                    172: out_bitmap = 128'h00C0C0C2C6CC183066CE9E3E06060000;
                    173: out_bitmap = 128'h00001818001818183C3C3C1800000000;
                    174: out_bitmap = 128'h0000000000366CD86C36000000000000;
                    175: out_bitmap = 128'h0000000000D86C366CD8000000000000;
                    176: out_bitmap = 128'h11441144114411441144114411441144;
                    177: out_bitmap = 128'h55AA55AA55AA55AA55AA55AA55AA55AA;
                    178: out_bitmap = 128'hDD77DD77DD77DD77DD77DD77DD77DD77;
                    179: out_bitmap = 128'h18181818181818181818181818181818;
                    180: out_bitmap = 128'h18181818181818F81818181818181818;
                    181: out_bitmap = 128'h1818181818F818F81818181818181818;
                    182: out_bitmap = 128'h36363636363636F63636363636363636;
                    183: out_bitmap = 128'h00000000000000FE3636363636363636;
                    184: out_bitmap = 128'h0000000000F818F81818181818181818;
                    185: out_bitmap = 128'h3636363636F606F63636363636363636;
                    186: out_bitmap = 128'h36363636363636363636363636363636;
                    187: out_bitmap = 128'h0000000000FE06F63636363636363636;
                    188: out_bitmap = 128'h3636363636F606FE0000000000000000;
                    189: out_bitmap = 128'h36363636363636FE0000000000000000;
                    190: out_bitmap = 128'h1818181818F818F80000000000000000;
                    191: out_bitmap = 128'h00000000000000F81818181818181818;
                    192: out_bitmap = 128'h181818181818181F0000000000000000;
                    193: out_bitmap = 128'h18181818181818FF0000000000000000;
                    194: out_bitmap = 128'h00000000000000FF1818181818181818;
                    195: out_bitmap = 128'h181818181818181F1818181818181818;
                    196: out_bitmap = 128'h00000000000000FF0000000000000000;
                    197: out_bitmap = 128'h18181818181818FF1818181818181818;
                    198: out_bitmap = 128'h18181818181F181F1818181818181818;
                    199: out_bitmap = 128'h36363636363636373636363636363636;
                    200: out_bitmap = 128'h363636363637303F0000000000000000;
                    201: out_bitmap = 128'h00000000003F30373636363636363636;
                    202: out_bitmap = 128'h3636363636F700FF0000000000000000;
                    203: out_bitmap = 128'h0000000000FF00F73636363636363636;
                    204: out_bitmap = 128'h36363636363730373636363636363636;
                    205: out_bitmap = 128'h0000000000FF00FF0000000000000000;
                    206: out_bitmap = 128'h3636363636F700F73636363636363636;
                    207: out_bitmap = 128'h1818181818FF00FF0000000000000000;
                    208: out_bitmap = 128'h36363636363636FF0000000000000000;
                    209: out_bitmap = 128'h0000000000FF00FF1818181818181818;
                    210: out_bitmap = 128'h00000000000000FF3636363636363636;
                    211: out_bitmap = 128'h363636363636363F0000000000000000;
                    212: out_bitmap = 128'h18181818181F181F0000000000000000;
                    213: out_bitmap = 128'h00000000001F181F1818181818181818;
                    214: out_bitmap = 128'h000000000000003F3636363636363636;
                    215: out_bitmap = 128'h36363636363636FF3636363636363636;
                    216: out_bitmap = 128'h1818181818FF18FF1818181818181818;
                    217: out_bitmap = 128'h18181818181818F80000000000000000;
                    218: out_bitmap = 128'h000000000000001F1818181818181818;
                    219: out_bitmap = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
                    220: out_bitmap = 128'h00000000000000FFFFFFFFFFFFFFFFFF;
                    221: out_bitmap = 128'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0;
                    222: out_bitmap = 128'h0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F;
                    223: out_bitmap = 128'hFFFFFFFFFFFFFF000000000000000000;
                    224: out_bitmap = 128'h000000000076DCD8D8D8DC7600000000;
                    225: out_bitmap = 128'h000078CCCCCCD8CCC6C6C6CC00000000;
                    226: out_bitmap = 128'h0000FEC6C6C0C0C0C0C0C0C000000000;
                    227: out_bitmap = 128'h00000000FE6C6C6C6C6C6C6C00000000;
                    228: out_bitmap = 128'h000000FEC66030183060C6FE00000000;
                    229: out_bitmap = 128'h00000000007ED8D8D8D8D87000000000;
                    230: out_bitmap = 128'h0000000066666666667C6060C0000000;
                    231: out_bitmap = 128'h0000000076DC18181818181800000000;
                    232: out_bitmap = 128'h0000007E183C6666663C187E00000000;
                    233: out_bitmap = 128'h000000386CC6C6FEC6C66C3800000000;
                    234: out_bitmap = 128'h0000386CC6C6C66C6C6C6CEE00000000;
                    235: out_bitmap = 128'h00001E30180C3E666666663C00000000;
                    236: out_bitmap = 128'h00000000007EDBDBDB7E000000000000;
                    237: out_bitmap = 128'h00000003067EDBDBF37E60C000000000;
                    238: out_bitmap = 128'h00001C3060607C606060301C00000000;
                    239: out_bitmap = 128'h0000007CC6C6C6C6C6C6C6C600000000;
                    240: out_bitmap = 128'h00000000FE0000FE0000FE0000000000;
                    241: out_bitmap = 128'h0000000018187E18180000FF00000000;
                    242: out_bitmap = 128'h00000030180C060C1830007E00000000;
                    243: out_bitmap = 128'h0000000C18306030180C007E00000000;
                    244: out_bitmap = 128'h00000E1B1B1818181818181818181818;
                    245: out_bitmap = 128'h1818181818181818D8D8D87000000000;
                    246: out_bitmap = 128'h000000001818007E0018180000000000;
                    247: out_bitmap = 128'h000000000076DC0076DC000000000000;
                    248: out_bitmap = 128'h00386C6C380000000000000000000000;
                    249: out_bitmap = 128'h00000000000000181800000000000000;
                    250: out_bitmap = 128'h00000000000000001800000000000000;
                    251: out_bitmap = 128'h000F0C0C0C0C0CEC6C6C3C1C00000000;
                    252: out_bitmap = 128'h00D86C6C6C6C6C000000000000000000;
                    253: out_bitmap = 128'h0070D83060C8F8000000000000000000;
                    254: out_bitmap = 128'h000000007C7C7C7C7C7C7C0000000000;
                    default: out_bitmap = 128'h00000000000000000000000000000000;
                endcase
            end
        end
    end
    
endmodule
