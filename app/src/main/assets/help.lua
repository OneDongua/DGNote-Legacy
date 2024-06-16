require "import"
import "mod"
import "color"

if File(pathc.."help.zip").isFile() then
  LuaUtil.unZip(pathc.."help.zip",pathh)
end

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
        gravity="center";
        id="mainTitle";
        text="Tips";
        textSize="20sp";
        layout_height="fill";
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
      text="出错了";
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

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
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
          {
            TextView;
            maxLines="5";
            id="noteText";
            textSize="15sp";
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
    function anim(view)
      local Y = ObjectAnimator.ofFloat(view.getParent(),"X",{view.getParent().getX(),activity.getWidth()})
      Y.setInterpolator(DecelerateInterpolator())
      Y.setDuration(300)
      Y.start()
    end
    local view=holder.view.getTag()
    if data[position+1].type==0 then
      view.noteTitle.Text="[文件夹]"..data[position+1].title
      view.noteText.setVisibility(View.GONE)

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(true)

      设置字体(view.noteTitle)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        loadNote(tostring(oriPath).."/")
      end
     elseif data[position+1].type==1 then
      view.noteTitle.Text=data[position+1].title
      if data[position+1].text=="" then
        view.noteText.setVisibility(View.GONE)
       else
        local text=data[position+1].text:gsub("!%[.-%]%(.-%)","[图片]"):gsub("\n%[浏览%]",""):gsub("\n\n","\n")
        view.noteText.setText(text)
        view.noteText.setVisibility(View.VISIBLE)
      end

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(true)
      view.noteText.setTextColor(COLOR_ON_BACKGROUND_SEC)

      设置字体(view.noteTitle)
      设置字体(view.noteText)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        thisNote={}
        thisNote.path=tostring(oriPath)
        thisNote.ishelp=true
        activity.newActivity("amend",{thisNote})
      end
    end
  end
}))

mainRecycler.setAdapter(adapter)
mainRecycler.setLayoutManager(StaggeredGridLayoutManager(
(sharedData.listmode_Index or 2),
StaggeredGridLayoutManager.VERTICAL))

function loadNote(path)
  thisPath=path

  if path ~= pathh then
    mainTitle.setText(File(path).getName())
   else
    mainTitle.setText("Tips")
  end

  ls=luajava.astable(File(path).listFiles())
  data={}
  if next(ls)~=nil then
    sort(ls)
    for k,v in ipairs(ls) do
      if v.isDirectory() then
        table.insert(data,{["path"]=v,["title"]=v.getName(),["type"]=0})
       elseif v.isFile() then
        local fullText = 读取文件(v)
        local text
        if String(fullText).length() > 200 then
          text = String(fullText).substring(0, 200)
         else
          text = fullText
        end
        table.insert(data,{["path"]=v,["title"]=v.getName(),["text"]=text,["type"]=1})
      end
    end
    emptyText.setVisibility(View.GONE)
   else
    emptyText.setVisibility(View.VISIBLE)
  end

  adapter.notifyDataSetChanged()
end

function onResume()
  loadNote(thisPath)
end

mainTitle.onClick=function(view)
  mainRecycler.smoothScrollToPosition(0)
end

back.onClick=function(view)
  activity.finish()
end

loadNote(pathh)
