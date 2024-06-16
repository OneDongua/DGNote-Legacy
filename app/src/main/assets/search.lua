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
      layout_width="fill";
      layout_height="fill";
      layout_gravity="center";
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
        gravity="center";
        id="mainTitle";
        text="搜索：";
        textSize="20sp";
        layout_height="fill";
      };
      {
        EditText;
        layout_width="fill";
        layout_gravity="center";
        singleLine="true";
        id="searchEdit";
        textSize="18sp";
        hint="标题或内容";
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
      text="无结果";
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
thisPath=data["parentPath"]

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
searchEdit.setTextColor(COLOR_ON_MAIN)
设置字体(searchEdit)

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
          {
            TextView;
            maxLines="1";
            id="noteDate";
            textSize="11sp";
            gravity="right";
            layout_width="fill";
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
    view.noteTitle.Text=data[position+1].title
    if data[position+1].text=="" then
      view.noteText.setVisibility(View.GONE)
     else
      view.noteText.setText(data[position+1].text)
      view.noteText.setVisibility(View.VISIBLE)
    end
    view.noteDate.Text=data[position+1].date

    view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
    view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
    view.noteTitle.getPaint().setFakeBoldText(true)
    view.noteText.setTextColor(COLOR_ON_BACKGROUND_SEC)

    设置字体(view.noteTitle)
    设置字体(view.noteText)
    设置字体(view.noteDate)

    水波纹(view.noteBg)

    view.noteBg.onClick=function(view)
      thisNote={}
      thisNote.path=tostring(oriPath)
      activity.newActivity("amend",{thisNote})
    end
  end
}))

mainRecycler.setAdapter(adapter)
mainRecycler.setLayoutManager(StaggeredGridLayoutManager(
(sharedData.listmode_Index or 2),
StaggeredGridLayoutManager.VERTICAL))

function searchNote(path,name)
  if path ~= pathn then
    mainTitle.setText(File(path).getName().."：")
   else
    mainTitle.setText("搜索：")
  end

  empty=false
  data={}
  function searchContext(searchPath)
    ls=luajava.astable(File(searchPath).listFiles())
    if next(ls)~=nil then
      sort(ls)
      for k,v in pairs(ls) do
        if v.isFile() then
          local title=v.getName()
          local text=读取文件(v)
          local date=文件修改时间(v)
          if string.upper(title):find(string.upper(name)) or string.upper(text):find(string.upper(name)) then
            empty=true
            if String(text).length() > 200 then
              text = String(text).substring(0, 200)
            end
            table.insert(data,{["path"]=v,["title"]=title,["text"]=text,["date"]=date})
          end
         elseif v.isDirectory() then
          searchContext(tostring(v))
        end
      end
    end
  end
  searchContext(path)
  if empty then
    emptyText.setVisibility(View.GONE)
   else
    emptyText.setVisibility(View.VISIBLE)
  end

  adapter.notifyDataSetChanged()
end

searchEdit.addTextChangedListener{
  onTextChanged=function(s)
    searchNote(thisPath,searchEdit.Text)
end}

function onKeyDown(keycode,event)
  if keycode == 4 then
    activity.finish()
    return true
  end
end

mainTitle.onClick=function(view)
  mainRecycler.smoothScrollToPosition(0)
end

back.onClick=function(view)
  activity.finish()
end

searchNote(thisPath,"")
