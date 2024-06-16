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
    paddingRight="12dp";
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
      Text="选择：";
      textSize="20sp";
      id="mainTitle";
    };
    {
      LinearLayout;
      layout_width="fill";
      layout_height="fill";
      {
        HorizontalScrollView;
        id="pathTextScroll";
        layout_width="fill";
        layout_height="fill";
        HorizontalScrollBarEnabled=false;
        overScrollMode=View.OVER_SCROLL_NEVER;
        {
          TextView;
          id="pathText";
          gravity="center";
          textSize="20sp";
          layout_height="fill";
        };
      };
    };
  };
  {
    FrameLayout;
    id="mainBackground";
    layout_width="fill";
    layout_height="fill";
    {
      TextView;
      id="emptyText";
      text="没有更多了";
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

data=...
ext=luajava.astable(data)

function filter(path)
  for k,v in ipairs(ext) do
    if File(path).getName():find(ext[k])
      activity.setSharedData("selected",path)
      activity.finish()
    end
  end
end

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
pathText.setTextColor(COLOR_ON_MAIN)
设置字体(mainTitle)
设置字体(pathText)

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
        CardView;
        radius="12dp";
        elevation="2";
        layout_margin="4dp";
        id="noteCard";
        layout_height="fill";
        layout_width="fill";
        {
          LinearLayout;
          id="noteBg";
          layout_width="fill";
          padding="14dp";
          layout_height="fill";
          Orientation="vertical";
          {
            TextView;
            maxLines="2";
            id="noteTitle";
            textSize="17sp";
            ellipsize="end";
          };
        };
      };
    },views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder=function(holder,position)
    local oriPath=data[position+1].path
    local view=holder.view.getTag()
    if data[position+1].type==0 then
      view.noteTitle.Text=data[position+1].title.."/"

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(false)

      设置字体(view.noteTitle)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        loadFile(tostring(oriPath).."/")
      end
     elseif data[position+1].type==1 then
      view.noteTitle.Text=data[position+1].title

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(true)

      设置字体(view.noteTitle)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        filter(tostring(oriPath))
      end
    end
  end
}))

mainRecycler.setAdapter(adapter)
mainRecycler.setLayoutManager(LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false))

function loadFile(path)
  thisPath=path

  pathText.setText(path)
  task(1,function()
    pathTextScroll.fullScroll(View.FOCUS_RIGHT)
  end)

  ls=luajava.astable(File(path).listFiles())
  data={}
  if next(ls)~=nil then
    sort(ls, 1)
    for k,v in ipairs(ls) do
      if v.isDirectory() then
        table.insert(data,{["path"]=v,["title"]=v.getName(),["type"]=0})
       elseif v.isFile() then
        table.insert(data,{["path"]=v,["title"]=v.getName(),["type"]=1})
      end
    end
    emptyText.setVisibility(View.GONE)
   else
    emptyText.setVisibility(View.VISIBLE)
  end
  adapter.notifyDataSetChanged()

end

function onResume()
  loadFile(thisPath)
end

back.onClick=function(view)
  if thisPath ~= sdPath then
    loadFile(父目录(thisPath))
   else
    activity.finish()
  end
end

function onKeyDown(keycode,event)
  if keycode == 4 then
    if thisPath ~= sdPath then
      loadFile(父目录(thisPath))
     else
      activity.finish()
    end
  end
  return true
end

loadFile(sdPath)