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
      paddingLeft="16dp";
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
        text="多选：";
        textSize="20sp";
        layout_height="fill";
      };
    };
    {
      LinearLayout;
      layout_height="fill";
      layout_gravity="center|right";
      paddingRight="12dp";
      {
        ImageView;
        id="selectAll";
        src=ICON_SELECT_ALL;
        layout_width="42dp";
        layout_height="24dp";
        layout_gravity="center";
      };
      {
        ImageView;
        id="move";
        src=ICON_MOVE_FILE;
        layout_width="42dp";
        layout_height="24dp";
        layout_gravity="center";
      };
      {
        ImageView;
        id="delete";
        src=ICON_DELETE;
        layout_width="42dp";
        layout_height="24dp";
        layout_gravity="center";
      };
      {
        ImageView;
        id="restore";
        src=ICON_RESTORE;
        layout_width="42dp";
        layout_height="24dp";
        layout_gravity="center";
      };
    };
  };
  {
    FrameLayout;
    layout_width="fill";
    layout_height="fill";
    {
      FrameLayout;
      id="mainBackground";
      layout_width="fill";
      layout_height="fill";
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
  };
}

arg = ...
path = arg.path
from = arg.from

设置视图(layout2)

水波纹(back)
水波纹(selectAll)
水波纹(move)
水波纹(delete)
水波纹(restore)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)

if from == "main" then
  restore.setVisibility(View.GONE)
 elseif from == "recycle" then
  move.setVisibility(View.GONE)
end

ls=luajava.astable(File(path).listFiles())
data={}
if next(ls)~=nil then
  sort(ls)
  for k,v in ipairs(ls) do
    if v.isDirectory() then
      table.insert(data,{path=v,title=v.getName(),type=0,seleted=false})
     elseif v.isFile() then
      local fullText = 读取文件(v)
      local text
      if String(fullText).length() > 200 then
        text = String(fullText).substring(0, 200)
       else
        text = fullText
      end
      table.insert(data,{path=v,title=v.getName(),text=text,date=文件修改时间(v),type=1,selected=false})
    end
  end
  emptyText.setVisibility(View.GONE)
 else
  emptyText.setVisibility(View.VISIBLE)
end

function refresh()
  selectedCount = 0
  selectedPathTable = {}
  for k, v in ipairs(data) do
    if v.selected then
      selectedCount = selectedCount + 1
      table.insert(selectedPathTable, v.path.toString())
    end
  end
  mainTitle.setText("多选："..tostring(selectedCount).."/"..tostring(#data))
end
refresh()

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
      view.noteDate.setVisibility(View.GONE)

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(true)

      设置字体(view.noteTitle)

      水波纹(view.noteBg)

      if data[position+1].selected then
        view.noteBg.setBackgroundColor(COLOR_CARD_SELECTED)
       else
        view.noteBg.setBackgroundColor(COLOR_CARD_BACKGROUND)
      end
      view.noteBg.onClick=function(view)
        if data[position+1].selected then
          data[position+1].selected = false
         else
          data[position+1].selected = true
        end
        adapter.notifyItemChanged(position)
        refresh()
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
      view.noteDate.Text=data[position+1].date
      view.noteDate.setVisibility(View.VISIBLE)

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(true)
      view.noteText.setTextColor(COLOR_ON_BACKGROUND_SEC)

      设置字体(view.noteTitle)
      设置字体(view.noteText)
      设置字体(view.noteDate)

      水波纹(view.noteBg)

      if data[position+1].selected then
        view.noteBg.setBackgroundColor(COLOR_CARD_SELECTED)
       else
        view.noteBg.setBackgroundColor(COLOR_CARD_BACKGROUND)
      end
      view.noteBg.onClick=function(view)
        if data[position+1].selected then
          data[position+1].selected = false
         else
          data[position+1].selected = true
        end
        adapter.notifyItemChanged(position)
        refresh()
      end
    end
  end
}))

mainRecycler.setAdapter(adapter)
mainRecycler.setLayoutManager(StaggeredGridLayoutManager(
(sharedData.listmode_Index or 2),
StaggeredGridLayoutManager.VERTICAL))

mainTitle.onClick=function(view)
  mainRecycler.smoothScrollToPosition(0)
end

back.onClick=function(view)
  if selectedCount == nil or selectedCount == 0 then
    activity.finish()
   else
    for k, v in ipairs(data) do
      data[k].selected = false
    end
    adapter.notifyDataSetChanged()
    refresh()
  end
end

selectAll.onClick=function(view)
  if selectedCount == #data then
    for k, v in ipairs(data) do
      data[k].selected = false
    end
   else
    for k, v in ipairs(data) do
      data[k].selected = true
    end
  end
  adapter.notifyDataSetChanged()
  refresh()
end

move.onClick=function(view)
  if next(selectedPathTable) then
    activity.newActivity("move", {selectedPathTable})
    activity.finish()
   else
    print("你还没有选择便签")
  end
end

delete.onClick=function(view)
  if from == "main" then
    local function multiRecycle()
      for k, v in ipairs(selectedPathTable) do
        os.execute("cp -rf \""..v.."\" \""..pathr.."\"")
      end
      local notSuccess
      for k, v in ipairs(selectedPathTable) do
        if File(pathr..File(v).getName()).exists() then
          os.execute("rm -rf \""..v.."\"")
         else
          notSuccess = true
        end
      end
      if not notSuccess then
        print("删除成功")
        updateWebdavInfo()
        activity.finish()
       else
        print("删除失败")
      end
    end
    if next(selectedPathTable) then
      AlertDialog.Builder(this)
      .setTitle("是否移至回收站？")
      .setPositiveButton("确定",{onClick=function(v)
          multiRecycle()
      end})
      .setNegativeButton("取消",nil)
      .show()
     else
      print("你还没有选择便签")
    end
   elseif from == "recycle" then
   local function multiDelete()
      for k, v in ipairs(selectedPathTable) do
        os.execute("rm -rf \""..v.."\"")
      end
      local notSuccess
      for k, v in ipairs(selectedPathTable) do
        if File(pathr..File(v).getName()).exists() then
          notSuccess = true
        end
      end
      if not notSuccess then
        print("删除成功")
        activity.finish()
       else
        print("删除失败")
      end
    end
    if next(selectedPathTable) then
      AlertDialog.Builder(this)
      .setTitle("是否彻底删除？")
      .setPositiveButton("确定",{onClick=function(v)
          multiDelete()
      end})
      .setNegativeButton("取消",nil)
      .show()
     else
      print("你还没有选择便签")
    end
  end
end

restore.onClick=function(view)
  local function multiRestore()
    for k, v in ipairs(selectedPathTable) do
      os.execute("cp -rf \""..v.."\" \""..pathn.."\"")
    end
    local notSuccess
    for k, v in ipairs(selectedPathTable) do
      if File(pathn..File(v).getName()).exists() then
        os.execute("rm -rf \""..v.."\"")
       else
        notSuccess = true
      end
    end
    if not notSuccess then
      print("恢复成功")
      updateWebdavInfo()
      activity.finish()
     else
      print("恢复失败")
    end
  end
  if next(selectedPathTable) then
    AlertDialog.Builder(this)
    .setTitle("是否恢复？")
    .setPositiveButton("确定",{onClick=function(v)
        multiRestore()
    end})
    .setNegativeButton("取消",nil)
    .show()
   else
    print("你还没有选择便签")
  end
end

function onKeyDown(keycode, event)
  if keycode == 4 then
    if selectedCount == nil or selectedCount == 0 then
      activity.finish()
     else
      for k, v in ipairs(data) do
        data[k].selected = false
      end
      adapter.notifyDataSetChanged()
      refresh()
    end
    return true
  end
end