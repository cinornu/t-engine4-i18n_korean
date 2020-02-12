# Colors
Implementation: @{engine.colors}

## Usage
T-Engine provides a number of predefined colors.  There are two ways to refer to these:

<ul>
<li>In your Lua code.  For example: <code>color.DARK_GREEN</code></li>
<li>Embedded within strings (using # signs to mark them).  For example: <code>"Hello, #BLUE#world#LAST#!"</code></li>
</ul>


You can add your own colours to the list for your module by adding in a line like the following to the <code>/load.lua</code> file:
<pre>defineColor('MAUVE', 204, 153, 255)</pre>

References to "MAUVE" will then result in this colour. You can define as many colours with as many names as you like. It can sometimes to helpful to name the colours based on what they're used for rather than the colours themselves. Eg, a colour for lightning attacks could be called "LIGHTNING".

## Presets
The following colors are defined by T-Engine 4:

<!-- Useful with: http://regexr.com/
REGEX for table generation for HEX Values:
/defineColor\('(\S+)',\s*((?:0x)(\S+)),\s*((?:0x)(\S+)),\s*((?:0x)(\S+))\)/g

Substitution for HEX values:
<tr><td>$1</td><td>$2</td><td>$4</td><td>$6</td><td class="color" style="background: #$3$5$7;"></td></tr>

REGEX for table generation for RGB values:
/defineColor\('(\S+)',\s*(\d+),\s*(\d+),\s*(\d+)\)/g

Substitution for RGB values:
<tr><td>$1</td><td>$2</td><td>$3</td><td>$3</td><td class="color" style="background: rgb($2,$3,$4);"></td></tr>
-->

<table class="colortable">
<thead>
<tr><th>Name</th><th>Red</th><th>Green</th><th>Blue</th><th>Demo</th></tr>
</thead>
<tbody>
<tr><td>BLACK</td><td>0</td><td>0</td><td>0</td><td class="color" style="background: rgb(0,0,0);"></td></tr> 
<tr><td>WHITE</td><td>0xFF</td><td>0xFF</td><td>0xFF</td><td class="color" style="background: #FFFFFF;"></td></tr>
<tr><td>SLATE</td><td>0x8C</td><td>0x8C</td><td>0x8C</td><td class="color" style="background: #8C8C8C;"></td></tr>
<tr><td>ORANGE</td><td>0xFF</td><td>0x77</td><td>0x00</td><td class="color" style="background: #FF7700;"></td></tr>
<tr><td>RED</td><td>0xC9</td><td>0x00</td><td>0x00</td><td class="color" style="background: #C90000;"></td></tr>
<tr><td>GREEN</td><td>0x00</td><td>0x86</td><td>0x45</td><td class="color" style="background: #008645;"></td></tr>
<tr><td>BLUE</td><td>0x00</td><td>0x00</td><td>0xE3</td><td class="color" style="background: #0000E3;"></td></tr>
<tr><td>UMBER</td><td>0x8E</td><td>0x45</td><td>0x00</td><td class="color" style="background: #8E4500;"></td></tr>
<tr><td>LIGHT_DARK</td><td>0x50</td><td>0x50</td><td>0x50</td><td class="color" style="background: #505050;"></td></tr>
<tr><td>LIGHT_SLATE</td><td>0xD1</td><td>0xD1</td><td>0xD1</td><td class="color" style="background: #D1D1D1;"></td></tr>
<tr><td>VIOLET</td><td>0xC0</td><td>0x00</td><td>0xAF</td><td class="color" style="background: #C000AF;"></td></tr>
<tr><td>YELLOW</td><td>0xFF</td><td>0xFF</td><td>0x00</td><td class="color" style="background: #FFFF00;"></td></tr>
<tr><td>LIGHT_RED</td><td>0xFF</td><td>0x00</td><td>0x68</td><td class="color" style="background: #FF0068;"></td></tr>
<tr><td>LIGHT_GREEN</td><td>0x00</td><td>0xFF</td><td>0x00</td><td class="color" style="background: #00FF00;"></td></tr>
<tr><td>LIGHT_BLUE</td><td>0x51</td><td>0xDD</td><td>0xFF</td><td class="color" style="background: #51DDFF;"></td></tr>
<tr><td>LIGHT_UMBER</td><td>0xD7</td><td>0x8E</td><td>0x45</td><td class="color" style="background: #D78E45;"></td></tr>
<tr><td>DARK_UMBER</td><td>0x57</td><td>0x5E</td><td>0x25</td><td class="color" style="background: #575E25;"></td></tr>

<tr><td>DARK_GREY</td><td>67</td><td>67</td><td>67</td><td class="color" style="background: rgb(67,67,67);"></td></tr>
<tr><td>GREY</td><td>127</td><td>127</td><td>127</td><td class="color" style="background: rgb(127,127,127);"></td></tr>

<tr><td>ROYAL_BLUE</td><td>65</td><td>105</td><td>105</td><td class="color" style="background: rgb(65,105,225);"></td></tr>
<tr><td>AQUAMARINE</td><td>127</td><td>255</td><td>255</td><td class="color" style="background: rgb(127,255,212);"></td></tr>
<tr><td>CADET_BLUE</td><td>95</td><td>158</td><td>158</td><td class="color" style="background: rgb(95,158,160);"></td></tr>
<tr><td>STEEL_BLUE</td><td>70</td><td>130</td><td>130</td><td class="color" style="background: rgb(70,130,180);"></td></tr>
<tr><td>TEAL</td><td>0</td><td>128</td><td>128</td><td class="color" style="background: rgb(0,128,128);"></td></tr>
<tr><td>LIGHT_STEEL_BLUE</td><td>176</td><td>196</td><td>196</td><td class="color" style="background: rgb(176,196,222);"></td></tr>
<tr><td>DARK_BLUE</td><td>0x00</td><td>0x00</td><td>0x93</td><td class="color" style="background: #000093;"></td></tr>
<tr><td>ROYAL_BLUE</td><td>0x00</td><td>0x6C</td><td>0xFF</td><td class="color" style="background: #006CFF;"></td></tr>

<tr><td>PINK</td><td>255</td><td>192</td><td>192</td><td class="color" style="background: rgb(255,192,203);"></td></tr>
<tr><td>GOLD</td><td>255</td><td>215</td><td>215</td><td class="color" style="background: rgb(255,215,0);"></td></tr>
<tr><td>FIREBRICK</td><td>178</td><td>34</td><td>34</td><td class="color" style="background: rgb(178,34,34);"></td></tr>
<tr><td>DARK_RED</td><td>100</td><td>0</td><td>0</td><td class="color" style="background: rgb(100,0,0);"></td></tr>
<tr><td>VERY_DARK_RED</td><td>50</td><td>0</td><td>0</td><td class="color" style="background: rgb(50,0,0);"></td></tr>
<tr><td>CRIMSON</td><td>220</td><td>20</td><td>20</td><td class="color" style="background: rgb(220,20,60);"></td></tr>
<tr><td>MOCCASIN</td><td>255</td><td>228</td><td>228</td><td class="color" style="background: rgb(255,228,181);"></td></tr>
<tr><td>KHAKI</td><td>240</td><td>230</td><td>230</td><td class="color" style="background: rgb(240,230,130);"></td></tr>
<tr><td>SANDY_BROWN</td><td>244</td><td>164</td><td>164</td><td class="color" style="background: rgb(244,164,96);"></td></tr>
<tr><td>SALMON</td><td>250</td><td>128</td><td>128</td><td class="color" style="background: rgb(250,128,114);"></td></tr>

<tr><td>DARK_ORCHID</td><td>153</td><td>50</td><td>50</td><td class="color" style="background: rgb(153,50,204);"></td></tr>
<tr><td>ORCHID</td><td>218</td><td>112</td><td>112</td><td class="color" style="background: rgb(218,112,214);"></td></tr>
<tr><td>PURPLE</td><td>128</td><td>0</td><td>0</td><td class="color" style="background: rgb(128,0,139);"></td></tr>

<tr><td>CHOCOLATE</td><td>210</td><td>105</td><td>105</td><td class="color" style="background: rgb(210,105,30);"></td></tr>
<tr><td>DARK_KHAKI</td><td>189</td><td>183</td><td>183</td><td class="color" style="background: rgb(189,183,107);"></td></tr>
<tr><td>TAN</td><td>210</td><td>180</td><td>180</td><td class="color" style="background: rgb(210,180,140);"></td></tr>
<tr><td>DARK_TAN</td><td>110</td><td>80</td><td>80</td><td class="color" style="background: rgb(110,80,40);"></td></tr>

<tr><td>HONEYDEW</td><td>240</td><td>255</td><td>255</td><td class="color" style="background: rgb(240,255,240);"></td></tr>
<tr><td>ANTIQUE_WHITE</td><td>250</td><td>235</td><td>235</td><td class="color" style="background: rgb(250,235,215);"></td></tr>
<tr><td>OLD_LACE</td><td>253</td><td>245</td><td>245</td><td class="color" style="background: rgb(253,245,230);"></td></tr>
<tr><td>DARK_SLATE_GRAY</td><td>47</td><td>79</td><td>79</td><td class="color" style="background: rgb(47,79,79);"></td></tr>

<tr><td>OLIVE_DRAB</td><td>107</td><td>142</td><td>142</td><td class="color" style="background: rgb(107,142,35);"></td></tr>
<tr><td>DARK_SEA_GREEN</td><td>143</td><td>188</td><td>188</td><td class="color" style="background: rgb(143,188,143);"></td></tr>
<tr><td>YELLOW_GREEN</td><td>154</td><td>205</td><td>205</td><td class="color" style="background: rgb(154,205,50);"></td></tr>
<tr><td>DARK_GREEN</td><td>50</td><td>77</td><td>77</td><td class="color" style="background: rgb(50,77,12);"></td></tr>
</tbody>
</table>