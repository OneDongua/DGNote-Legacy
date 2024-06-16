require "import"
import "mod"
import "color"

layout2={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  {
    LinearLayout;
    layout_height="56dp";
    layout_width="fill";
    id="mainActionBar";
    elevation=4;
    gravity="left|center";
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
      Text="字体";
      textSize="20sp";
      id="mainTitle";
    };
  };
  {
    FrameLayout;
    id="mainBackground";
    layout_width="fill";
    layout_height="fill";
    {
      CardView;
      layout_width="56dp";
      layout_height="56dp";
      layout_marginRight="24dp";
      layout_marginBottom="32dp";
      layout_gravity="right|bottom";
      radius="28dp";
      id="fab";
      {
        LinearLayout;
        layout_width="fill";
        layout_height="fill";
        gravity="center";
        id="add";
        {
          ImageView;
          src=ICON_ADD;
          layout_width="24dp";
          layout_height="24dp";
        };
      };
    };
    {
      TextView;
      id="emptyText";
      text="空";
      layout_width="fill";
      layout_height="100%w";
      gravity="center";
    };
    {
      RecyclerView;
      id="mainRecycler";
      layout_width="fill";
      layout_height="wrap";
    };
  };
}

设置视图(layout2)

水波纹(back)
水波纹(add)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
fab.setBackgroundColor(COLOR_MAIN)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)

adapter=LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    local holder=LuaCustRecyclerHolder(loadlayout({
      LinearLayout;
      layout_height="wrap";
      layout_width="fill";
      {
        LinearLayout;
        layout_height="fill";
        layout_width="fill";
        backgroundColor=COLOR_MAIN_BACKGROUND;
        {
          LinearLayout;
          id="fontBackground";
          layout_width="fill";
          padding="16dp";
          layout_height="fill";
          Orientation="vertical";
          {
            TextView;
            maxLines="2";
            id="title";
            textSize="16sp";
          };
          {
            TextView;
            maxLines="2";
            id="text";
            textSize="14sp";
          };
          {
            TextView;
            id="preview";
            layout_width="fill";
            gravity="right";
            textSize="14sp";
            text="AaBbCcDdEeFfGg0123456789\n这是一段测试文字：你好！冬瓜便签";
          };
        };
      };
    }, views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder=function(holder, position)
    local view = holder.view.getTag()
    local f = data[position+1].font
    local k = position+1
    local fontTypeface = Typeface.createFromFile(tostring(f))

    水波纹(view.fontBackground)

    view.title.setText(f.getName():match("(.+)%.%w"))
    view.text.setText("/"..tostring(f):gsub(pathf,""))
    view.title.setTextColor(COLOR_ON_BACKGROUND)
    view.title.setTypeface(fontTypeface)
    view.text.setTypeface(fontTypeface)
    view.preview.setTypeface(fontTypeface)

    local using = (sharedData.font == f.getName())

    local function set()
      activity.setSharedData("font", f.getName())
      activity.setSharedData("font_Index", k+1)
      change = true
      refreshSharedData()
      loadFonts()
    end
    local function reset()
      activity.setSharedData("font", "无")
      activity.setSharedData("font_Index", 1)
      change = true
      refreshSharedData()
      loadFonts()
    end

    if using then
      view.fontBackground.setBackgroundColor(COLOR_CARD_SELECTED)
    end

    view.fontBackground.onClick=function(view)
      if using then
        reset()
       else
        set()
      end
    end

    view.fontBackground.onLongClick=function(view)
      AlertDialog.Builder(this)
      .setTitle("确认删除？")
      .setMessage("将无法恢复")
      .setPositiveButton("确认",{onClick=function(v)
          if using then
            reset()
          end
          os.remove(tostring(f))
          print("删除成功")
          refreshSharedData()
          loadFonts()
      end})
      .setNegativeButton("取消",nil)
      .show()
    end
  end
}))

mainRecycler.setAdapter(adapter)
mainRecycler.setLayoutManager(LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false))

function loadFonts()
  data={}

  local fontList=luajava.astable(File(pathf).listFiles())
  if next(fontList) then
    emptyText.setVisibility(View.GONE)
    for k, v in ipairs(fontList) do
      table.insert(data, {font=v})
    end
   else
    emptyText.setVisibility(View.VISIBLE)
  end

  adapter.notifyDataSetChanged()
end

add.onClick=function()
  ext={".ttf",".otf",".ttc"}
  activity.setSharedData("selected",nil)
  activity.newActivity("chooseFile",{ext})
end
back.onClick=function()
  if change then
    activity.newActivity("main").finishAffinity()
   else
    activity.finish()
  end
end

function onKeyDown(keycode, event)
  if keycode == 4 then
    if change then
      activity.newActivity("main").finishAffinity()
     else
      activity.finish()
    end
  end
end

function onResume()
  selected=activity.getSharedData("selected")
  if selected~=nil then
    os.execute("cp -f \""..selected.."\" "..pathf)
    activity.setSharedData("selected", nil)
    print("导入成功")
    loadFonts()
  end
end

loadFonts()
print("长按字体删除")
