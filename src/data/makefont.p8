pico-8 cartridge // http://www.pico-8.com
version 17
__lua__

local mul = 200
local glyphs = 0

local fillc = 0
local bg = 1
local fg = 7

function codepoint(n)
  local lut = {
    9646, 9632, 9633, 8281, 8280, 8214, 9664, 9654,
    12300, 12301, 165, 8226, 12289, 12290, 12443, 12444,
    9750, -- change this character one day
    9608, 9618, '128049', 11015, 9617, 10045, 9679, 9829,
    9737, '50883', 8962, 11013, '128528', 9834, '127358', 9670,
    8230, 10145, 9733, 10711, 11014, 711, 8743, 10062,
    9636, 9637, 12354, 12356, 12358, 12360, 12362, 12363,
    12365, 12367, 12369, 12371, 12373, 12375, 12377, 12379,
    12381, 12383, 12385, 12388, 12390, 12392, 12394, 12395,
    12396, 12397, 12398, 12399, 12402, 12405, 12408, 12411,
    12414, 12415, 12416, 12417, 12418, 12420, 12422, 12424,
    12425, 12426, 12427, 12428, 12429, 12431, 12434, 12435,
    12387, 12419, 12421, 12423, 12450, 12452, 12454, 12456,
    12458, 12459, 12461, 12463, 12465, 12467, 12469, 12471,
    12473, 12475, 12477, 12479, 12481, 12484, 12486, 12488,
    12490, 12491, 12492, 12493, 12494, 12495, 12498, 12501,
    12504, 12507, 12510, 12511, 12512, 12513, 12514, 12516,
    12518, 12520, 12521, 12522, 12523, 12524, 12525, 12527,
    12530, 12531, 12483, 12515, 12517, 12519, 9692, 9693
  }
  return n<32 and lut[n-15] or n>126 and lut[n-110] or n
end

local dx = { 1, 0, -1, 0,   1, 1, -1, -1,   1, 1, 0, 0 }
local dy = { 0, 1, 0, -1,   -1, 1, 1, -1,   0, 1, 1, 0 }

-- flood fill
function ffill(x,y,c)
  local c0 = pget(x,y)
  if c0==fillc or (c and c!=c0) then return end
  pset(x,y,fillc)
  for i=1,4 do ffill(x+dx[i],y+dy[i],c0) end
end

-- find bottom-left non-transparent char
function finddot()
  for dx=0,8 do
    for dy=7,0,-1 do
      if pget(dx,dy)!=fillc then
        return dx,dy
      end
    end
  end
end

-- build envelope for current char
function trace(sx,sy)
  local path, visited = { {sx,sy+1} }, {}
  local x,y,d = sx,sy,3
  repeat
    add(visited, {x,y})
    add(visited, {x+dy[d+1],y-dx[d+1]})
    local c = pget(x,y)
    local x1,y1 = x+dx[d+1],y+dy[d+1]
    local x2,y2 = x+dx[d+5],y+dy[d+5]
    local x3,y3 = x+dx[d+9],y+dy[d+9]
    if pget(x1,y1) != c then
      add(path,{x3,y3})
      d = (d+1)%4 -- turn right
    elseif pget(x2,y2) == c then
      add(path,{x3,y3})
      x,y,d = x2,y2,(d+3)%4 -- turn left
    else
      x,y = x1,y1
    end
  until x==sx and y==sy and d==3
  return path,visited
end

function output(path,rev)
  for i=1,#path do
    local p = path[rev and #path-i+1 or i]
    printh((i==1 and '' or ' ')..
           (p[1]*mul-mul).." "..
           (6*mul-p[2]*mul).." "..
           (i==1 and 'm' or 'l').." 1,"..
           ((i-1)%(#path-1))..",-1")
  end
end

function dochar(n)
  -- swap uppercase and lowercase
  local ch = chr(band(n,0xdf)>=0x41 and band(n,0xdf)<=0x5a and bxor(n,0x20) or n)
  local cpt = codepoint(n)
  local w = 4 + 4*flr(n/128)
  local h = 6
  doglyph(ch, cpt, cpt, cpt, w, h)
end

function doglyph(ch, name, enc1, enc2, w, h)
  printh('StartChar: '..name)
  printh('Encoding: '..enc1..' '..enc2..' '..glyphs)
  printh('Width: '..(w*mul))
  printh('VWidth: '..(6*mul))
  printh('GlyphClass: 2\nFlags: W\nLayerCount: 2\nFore\nSplineSet')
  glyphs += 1

  rectfill(0,0,7,7,bg)
  print(ch,1,1,fg)
  ffill(0,0)
  while true do
    local sx,sy = finddot()
    if not sx then break end
    path,visited = trace(sx,sy)
    output(path,pget(sx,sy)!=fg)
    for _,p in pairs(visited) do
      ffill(p[1],p[2])
    end
  end

  printh('EndSplineSet\nEndChar\n')
end

printh('SplineFontDB: 3.0')
printh('FontName: Zepto-8\nFullName: ZEPTO-8\nFamilyName: Zepto-8\nWeight: Book')
printh('Copyright: Sam Hocevar\n')
printh('Version: 1.0\n')
printh('ItalicAngle: 0')
printh('UnderlinePosition: -200\nUnderlineWidth: 200')
printh('Ascent: 1000\nDescent: 0')
printh('LayerCount: 2\nLayer: 0 1 "Back" 1\nLayer: 1 1 "Fore" 0\n')
printh('OS2Version: 2\nOS2_WeightWidthSlopeOnly: 0\nOS2_UseTypoMetrics: 0')
printh('PfmFamily: 81')
printh('TTFWeight: 400\nTTFWidth: 5')
printh('LineGap: 0\nVLineGap: 0\nPanose: 0 0 4 0 0 0 0 0 0 0\n')
printh('OS2TypoAscent: 1000\nOS2TypoAOffset: 0\nOS2TypoDescent: -200\nOS2TypoDOffset: 0\nOS2TypoLinegap: 0')
printh('OS2WinAscent: 1000\nOS2WinAOffset: 0\nOS2WinDescent: 200\nOS2WinDOffset: 0')
printh('HheadAscent: 1000\nHheadAOffset: 0\nHheadDescent: 200\nHheadDOffset: 0')
printh('OS2SubXSize: 400\nOS2SubYSize: 400\nOS2SubXOff: 0\nOS2SubYOff: -200')
printh('OS2SupXSize: 400\nOS2SupYSize: 400\nOS2SupXOff: 0\nOS2SupYOff: 400')
printh('OS2StrikeYSize: 40\nOS2StrikeYPos: 160')
printh('OS2CapHeight: 1000\nOS2XHeight: 800')
printh('GaspTable: 1 65535 2 0')
printh('Encoding: UnicodeFull')
printh('DisplaySize: -48')
printh('AntiAlias: 1')
printh('FitToEm: 0')

printh('BeginChars: 1114112 '..(256 - 16 + 3))
doglyph('0', '.notdef', '65536', -1, 4, 6)
doglyph('0', 'space', '65537', -1, 4, 6)
doglyph('', 'glyph1', '65538', -1, 0, 6)
for n=16,255 do dochar(n) end
printh('EndChars\nEndSplineFont')

