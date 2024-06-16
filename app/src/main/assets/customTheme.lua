require "import"
import "mod"
import "color"

layout2={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  {
    FrameLayout;
    layout_width="fill";
    layout_height="56dp";
    elevation=4;
    id="mainActionBar";
    {
      LinearLayout;
      layout_height="fill";
      layout_gravity="center|left";
      paddingLeft="12dp";
      {
        ImageView;
        id="back";
        src=ICON_BACK;
        layout_width="24dp";
        layout_height="24dp";
        layout_gravity="center";
        layout_marginRight="12dp";
      };
      {
        TextView;
        layout_width="wrap";
        layout_height="fill";
        text="自定义[浅色]";
        textSize="20sp";
        id="mainTitle";
        gravity="center";
      };
    };
    {
      LinearLayout;
      layout_height="fill";
      layout_gravity="center|right";
      paddingRight="12dp";
      {
        ImageView;
        id="mode";
        src=ICON_DARK_MODE;
        layout_width="24dp";
        layout_height="24dp";
        layout_gravity="center";
        layout_marginLeft="12dp";
      };
    };
  };
  {
    ScrollView;
    layout_width="fill";
    layout_height="fill";
    verticalScrollBarEnabled=false;
    id="mainBackground";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="fill";
      layout_height="fill";
      {
        ListView;
        id="itemList";
        layout_height="fill";
        layout_width="fill";
        dividerHeight="0";
        verticalScrollBarEnabled=false;
      };
      {
        LinearLayout;
        layout_height="wrap";
        layout_width="fill";
        backgroundColor=COLOR_MAIN_BACKGROUND;
        {
          FrameLayout;
          id="option1_bg";
          layout_height="fill";
          layout_width="fill";
          padding="16dp";
          {
            LinearLayout;
            layout_width="wrap";
            layout_height="fill";
            Orientation="vertical";
            {
              TextView;
              id="option1_name";
              maxLines="2";
              text="恢复默认";
              textSize="16sp";
              textColor=COLOR_ON_BACKGROUND;
            };

          };
        };
      };
    };
  };
}

设置视图(layout2)

水波纹(back)
水波纹(mode)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)

水波纹(option1_bg)

confPath = pathc.."ThemeConfig.json"
function restore()
  conf = {
    light={
      COLOR_ON_MAIN=0xFFFFFFFF;
      COLOR_MAIN=0xFF009688;
      COLOR_ACCENT=0xFF009688;
      COLOR_MAIN_BACKGROUND=0xFFF5F5F5;
      COLOR_CARD_BACKGROUND=0xFFFFFFFF;
      COLOR_ON_BACKGROUND=0xFF000000;
      COLOR_ON_BACKGROUND_SEC=0xFF000000;
    };
    dark={
      COLOR_ON_MAIN=0xFFFFFFFF;
      COLOR_MAIN=0xFF000000;
      COLOR_ACCENT=0xFF009688;
      COLOR_MAIN_BACKGROUND=0xFF161616;
      COLOR_CARD_BACKGROUND=0xFF202020;
      COLOR_ON_BACKGROUND=0xFFFFFFFF;
      COLOR_ON_BACKGROUND_SEC=0xFFFFFFFF;
    };
  }
end
restore()
if File(confPath).isFile() then
  conf = cjson.decode(读取文件(confPath))
 else
  写入文件(confPath, cjson.encode(conf))
end

switch isNightMode()
 case true
  editMode = 1
 default
  editMode = 0
end

mode.onClick=function(view)
  switch editMode
   case 0
    mode.setImageBitmap(loadbitmap(ICON_LIGHT_MODE))
    editMode = 1
    refreshList()
    mainTitle.setText("自定义[深色]")
   case 1
    mode.setImageBitmap(loadbitmap(ICON_DARK_MODE))
    editMode = 0
    refreshList()
    mainTitle.setText("自定义[浅色]")
  end
end

option1_bg.onClick=function(view)
  restore()
  refreshList()
end

function isDarkColor(color)
  color = math.floor(color)
  return (0.299 * Color.red(color) + 0.587 * Color.green(color) + 0.114 * Color.blue(color)) <192
end

function getOnTextColor(color)
  if isDarkColor(color) then
    return 0xFFFFFFFF
  end
  return 0xFF000000
end

item = {
  LinearLayout;
  layout_height="wrap";
  layout_width="fill";
  backgroundColor=COLOR_MAIN_BACKGROUND;
  {
    CardView;
    id="item";
    layout_height="wrap";
    layout_width="fill";
    layout_margin="4dp";
    radius="12dp";
    {
      LinearLayout;
      id="bg";
      layout_width="fill";
      layout_height="wrap";
      padding="16dp";
      {
        TextView;
        id="text";
        maxLines="2";
        textSize="16sp";
      };
      {
        TextView;
        id="name";
        layout_width="0dp";
        layout_height="0dp";
      };
    };
  };
};

function getData(mode, conf)
  local tab = {}
  switch editMode
   case 0
    tab = conf.light
   case 1
    tab = conf.dark
  end
  local data = {
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_MAIN or COLOR_MAIN);
      };
      text = {
        text="主题色";
        textColor=getOnTextColor(math.floor(tab.COLOR_MAIN or COLOR_MAIN));
      };
      name = {
        text = "COLOR_MAIN"
      };
    };
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_MAIN_BACKGROUND or COLOR_MAIN_BACKGROUND);
      };
      text = {
        text="主背景色";
        textColor=getOnTextColor(math.floor(tab.COLOR_MAIN_BACKGROUND or COLOR_MAIN_BACKGROUND));
      };
      name = {
        text = "COLOR_MAIN_BACKGROUND"
      };
    };
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_CARD_BACKGROUND or COLOR_CARD_BACKGROUND);
      };
      text = {
        text="卡片背景色";
        textColor=getOnTextColor(math.floor(tab.COLOR_CARD_BACKGROUND or COLOR_CARD_BACKGROUND));
      };
      name = {
        text = "COLOR_CARD_BACKGROUND"
      };
    };
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_ACCENT or COLOR_ACCENT);
      };
      text = {
        text="强调色";
        textColor=getOnTextColor(math.floor(tab.COLOR_ACCENT or COLOR_ACCENT));
      };
      name = {
        text = "COLOR_ACCENT"
      };
    };
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_ON_MAIN or COLOR_ON_MAIN);
      };
      text = {
        text="主题色上文字颜色";
        textColor=getOnTextColor(math.floor(tab.COLOR_ON_MAIN or COLOR_ON_MAIN));
      };
      name = {
        text = "COLOR_ON_MAIN"
      };
    };
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_ON_BACKGROUND or COLOR_ON_BACKGROUND);
      };
      text = {
        text="背景色上主文字颜色";
        textColor=getOnTextColor(math.floor(tab.COLOR_ON_BACKGROUND or COLOR_ON_BACKGROUND));
      };
      name = {
        text = "COLOR_ON_BACKGROUND"
      };
    };
    {
      bg = {
        backgroundColor=math.floor(tab.COLOR_ON_BACKGROUND_SEC or COLOR_ON_BACKGROUND_SEC);
      };
      text = {
        text="背景色上副文字颜色";
        textColor=getOnTextColor(math.floor(tab.COLOR_ON_BACKGROUND_SEC or COLOR_ON_BACKGROUND_SEC));
      };
      name = {
        text = "COLOR_ON_BACKGROUND_SEC"
      };
    };
  }
  return data
end

function refreshList()
  data = getData(editMode, conf)
  adp = LuaAdapter(activity, data, item)
  itemList.setAdapter(adp)
end
refreshList()

itemList.onItemClick = function(parent, view, pos, index)
  pickColorDialog(view.tag.bg.getBackground().getColor(), view.tag.name.text)
end

vto = itemList.getViewTreeObserver()
listViewDone = 0
vto.addOnGlobalLayoutListener({
  onGlobalLayout=function(view)
    if listViewDone < 1 then
      --获取ListView的高度
      local listViewHeight = itemList.getHeight()

      --获取ListView的内容高度
      local contentHeight = 0;
      for i = 1, adp.getCount() do
        local listItem = adp.getView(i, nil, itemList)
        listItem.measure(0, 0);
        contentHeight = contentHeight + listItem.getMeasuredHeight()
      end

      --动态设置ListView的高度
      local params = itemList.getLayoutParams()
      params.height = contentHeight + (itemList.getDividerHeight() * (adp.getCount() - 1))
      itemList.setLayoutParams(params)

      listViewDone = listViewDone + 1
    end
  end
})

colorLayout={
  LinearLayout;
  layout_width="fill";
  layout_height="wrap";
  orientation="vertical";
  gravity="center";
  padding="24dp";
  {
    CardView;
    id="colorBox";
    layout_width="fill";
    layout_height="48dp";
    radius="12dp";
    elevation=0;
    padding="24dp";
    focusable="true";
    focusableInTouchMode="true";
  };
  {
    EditText;
    id="colorText";
    layout_width="wrap";
    layout_height="wrap";
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_height="wrap";
    padding="4dp";
    {
      TextView;
      layout_width="14sp";
      gravity="center";
      text="R:";
    };
    {
      SeekBar;
      id="sb_red";
      layout_width="fill";
      layout_height="wrap";
    };
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_height="wrap";
    padding="4dp";
    {
      TextView;
      layout_width="14sp";
      gravity="center";
      text="G:";
    };
    {
      SeekBar;
      id="sb_green";
      layout_width="fill";
      layout_height="wrap";
    };
  };
  {
    LinearLayout;
    layout_width="fill";
    layout_height="wrap";
    padding="4dp";
    {
      TextView;
      layout_width="14sp";
      gravity="center";
      text="B:";
    };
    {
      SeekBar;
      id="sb_blue";
      layout_width="fill";
      layout_height="wrap";
    };
  };

}

function colorToRgb(color)
  local red = color >> 16 & 255
  local green = color >> 8 & 255
  local blue = color & 255
  return {r=red, g=green, b=blue}
end

function rgbToColor(rgb)
  return tonumber(string.format("0x%02x%02x%02x%02x", 255, rgb.r, rgb.g, rgb.b))
end

function colorToHexString(color)
  return "#"..string.sub(Integer.toHexString(color),3,8)
end

function hexStringToColor(hex)
  return tonumber("0xff"..string.sub(hex, 2, 7))
end

function pickColorDialog(color, name)
  local dialog = AlertDialog.Builder(activity)
  .setTitle("选择颜色")
  .setView(loadlayout(colorLayout))

  colorBox.setBackgroundColor(color)
  colorText.setText(colorToHexString(color))

  local rgb = colorToRgb(color)

  sb_red.setMax(255)
  sb_red.setProgress(rgb.r)

  sb_green.setMax(255)
  sb_green.setProgress(rgb.g)

  sb_blue.setMax(255)
  sb_blue.setProgress(rgb.b)

  local function refreshFromSeek()
    local color = rgbToColor(rgb)
    colorBox.setBackgroundColor(color)
    colorText.setText(colorToHexString(color))
  end

  local function refreshFromText()
    local color = rgbToColor(rgb)
    colorBox.setBackgroundColor(color)
    sb_red.setProgress(rgb.r)
    sb_green.setProgress(rgb.g)
    sb_blue.setProgress(rgb.b)
    colorText.setSelection(colorText.length())
  end

  sb_red.setOnSeekBarChangeListener{
    onProgressChanged=function(view, progress)
      rgb.r = progress
      refreshFromSeek()
  end}

  sb_green.setOnSeekBarChangeListener{
    onProgressChanged=function(view, progress)
      rgb.g = progress
      refreshFromSeek()
  end}

  sb_blue.setOnSeekBarChangeListener{
    onProgressChanged=function(view, progress)
      rgb.b = progress
      refreshFromSeek()
  end}

  local length = 7
  colorText.addTextChangedListener{
    afterTextChanged = function(s)
      if tostring(s):match("#%x%x%x%x%x%x") and length ~= 7 then
        rgb = colorToRgb(hexStringToColor(tostring(s)))
        refreshFromText()
       else
        length = s.length()
      end
  end}

  dialog.setPositiveButton("确定",{onClick=function(view)
      change = true
      local finalColor = rgbToColor(rgb)
      switch editMode
       case 0
        conf.light[name] = finalColor
       case 1
        conf.dark[name] = finalColor
      end
      refreshList()
  end})
  .setNegativeButton("取消", nil)
  .show()
end

function saveConf()
  if isDarkColor(conf.light.COLOR_MAIN) then
    conf.light.PREF_UIMODE_MAIN = "white"
   else
    conf.light.PREF_UIMODE_MAIN = "black"
  end
  if isDarkColor(conf.dark.COLOR_MAIN) then
    conf.dark.PREF_UIMODE_MAIN = "white"
   else
    conf.dark.PREF_UIMODE_MAIN = "black"
  end
  写入文件(confPath, cjson.encode(conf))
end

back.onClick=function(v)
  if change then
    saveConf()
    activity.newActivity("main").finishAffinity()
   else
    activity.finish()
  end
end

function onKeyDown(keycode, event)
  if keycode == 4 then
    if change then
      saveConf()
      activity.newActivity("main").finishAffinity()
     else
      activity.finish()
    end
  end
end
