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
    layout_width="fill";
    layout_height="56dp";
    elevation=4;
    id="mainActionBar";
    {
      LinearLayout;
      layout_width="wrap";
      layout_height="fill";
      paddingLeft="12dp";
      gravity="center";
      layout_weight=0;
      {
        ImageView;
        id="back";
        src=ICON_BACK;
        layout_width="24dp";
        layout_height="24dp";
        layout_marginRight="12dp";
      };
      {
        TextView;
        id="mainTitle";
        text="移动至:";
        textSize="20sp";
        layout_height="fill";
        gravity="center";
      };
    };
    {
      LinearLayout;
      layout_width="fill";
      layout_height="fill";
      layout_weight=1;
      {
        HorizontalScrollView;
        id="pathTitleView";
        layout_width="fill";
        layout_height="fill";
        HorizontalScrollBarEnabled=false;
        overScrollMode=View.OVER_SCROLL_NEVER;
        {
          TextView;
          id="pathTitle";
          gravity="center";
          text="/";
          textSize="20sp";
          layout_height="fill";
        };
      };
    };
    {
      LinearLayout;
      layout_width="wrap";
      layout_height="fill";
      paddingLeft="12dp";
      paddingRight="16dp";
      gravity="center";
      layout_weight=0;
      {
        ImageView;
        id="add";
        src=ICON_ADD;
        layout_width="24dp";
        layout_height="24dp";
      };
      {
        LinearLayout;
        layout_height="0dp";
        layout_width="16dp";
      };
      {
        ImageView;
        id="check";
        src=ICON_CHECK;
        layout_width="24dp";
        layout_height="24dp";
      };
    };
  };
  {
    ScrollView;
    layout_width="fill";
    layout_height="fill";
    VerticalScrollBarEnabled=false;
    id="mainBackground";
    {
      LinearLayout;
      orientation="vertical";
      id="NoteBackground1";
      layout_width="fill";
      layout_height="fill";
    };
  };
}


设置视图(layout2)

水波纹(add)
水波纹(check)
水波纹(back)

oldPath = ...
if type(oldPath) ~= "string" then
  oldPaths = luajava.astable(oldPath)
  multiple = true
end

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
mainTitle.setTextColor(COLOR_ON_MAIN)
pathTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
pathTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
设置字体(pathTitle)

function 加载笔记列表(path)
  thisPath=path
  task(1,function()pathTitleView.fullScroll(View.FOCUS_RIGHT)end)
  NoteList1={
    LinearLayout;
    id="NoteBackground2";
    Orientation="vertical";
    layout_width="fill";
    layout_height="fill";
  }
  NoteBackground1.addView(loadlayout(NoteList1))
  NoteList2={
    LinearLayout;
    id="NoteBackground3";
    layout_height="wrap";
    layout_width="fill";
    {
      CardView;
      radius="12dp";
      elevation="2";
      layout_margin="4dp";
      id="NoteBackground4";
      layout_height="fill";
      layout_width="fill";
      {
        LinearLayout;
        id="NoteBackground5";
        layout_width="fill";
        padding="14dp";
        layout_height="fill";
        Orientation="vertical";
        {
          TextView;
          maxLines="2";
          id="NoteTitle";
          textSize="17sp";
          ellipsize="end";
        };
        {
          TextView;
          maxLines="5";
          id="NoteText";
          textSize="15sp";
          ellipsize="end";
        };
      };
    };
  };
  --增加文件夹提示
  if path ~= pathn then
    pathTitle.setText("/"..tostring(path):gsub(pathn,""))
   else
    pathTitle.setText("/")
  end
  ls=luajava.astable(File(path).listFiles())
  if next(ls)~=nil then
    sort(ls)
  end
  data={}
  data.path={}
  for number, newpath in ipairs(ls) do
    local cannotMove
    if multiple then
      for k, v in ipairs(oldPaths) do
        if v == newpath.toString() then
          cannotMove = true
        end
      end
     else
      if newpath.getName() == File(oldPath).getName() then
        cannotMove = true
      end
    end

    if newpath.isDirectory() and not cannotMove then
      NoteBackground2.addView(loadlayout(NoteList2))
      NoteBackground3.setBackgroundColor(COLOR_MAIN_BACKGROUND)
      NoteBackground4.setBackgroundColor(COLOR_CARD_BACKGROUND)
      NoteBackground5.setBackgroundColor(COLOR_CARD_BACKGROUND)
      水波纹(NoteBackground5)
      NoteTitle.setTextColor(COLOR_ON_BACKGROUND)
      NoteText.setTextColor(COLOR_ON_BACKGROUND_SEC)
      NoteTitle.setText("[文件夹]"..newpath.getName())
      NoteText.setVisibility(View.GONE)
      NoteTitle.getPaint().setFakeBoldText(true)
      设置字体(NoteTitle)
      设置字体(NoteText)
      NoteBackground5.onClick=function(view)
        NoteBackground1.removeView(NoteBackground2)
        加载笔记列表(tostring(newpath).."/")
        return true
      end
      data.number=false
    end
  end
end

check.onClick=function(view)
  if multiple then
    local function multiMove()
      for k, v in ipairs(oldPaths) do
        os.execute("cp -rf \""..v.."\" \""..thisPath.."\"")
      end
      local notSuccess
      for k, v in ipairs(oldPaths) do
        if File(thisPath..File(v).getName()).exists() then
          os.execute("rm -rf \""..v.."\"")
         else
          notSuccess = true
        end
      end
      if not notSuccess then
        print("移动成功")
        updateWebdavInfo()
        activity.finish()
       else
        print("移动失败")
      end
    end
    AlertDialog.Builder(this)
    .setTitle("是否移动？")
    .setMessage("将会全部替换")
    .setPositiveButton("移动",{onClick=function(v)
        multiMove()
    end})
    .setNegativeButton("取消",nil)
    .show()
   else
    local function move()
      os.execute("cp -rf \""..oldPath.."\" \""..thisPath.."\"")
      if File(thisPath..File(oldPath).getName()).exists() then
        os.execute("rm -rf \""..oldPath.."\"")
        print("移动成功")
        updateWebdavInfo()
        activity.finish()
       else
        print("移动失败")
      end
    end
    if File(tostring(thisPath).."/"..File(oldPath).getName()).isFile() then
      AlertDialog.Builder(this)
      .setTitle("是否替换？")
      .setMessage("相同名称便签/文件夹已存在")
      .setPositiveButton("替换",{onClick=function(v)
          move()
      end})
      .setNegativeButton("取消",nil)
      .show()
     else
      move()
    end
  end
end

add.onClick=function(view)
  AlertDialog.Builder(this)
  .setTitle("新建文件夹")
  .setView(loadlayout({
    LinearLayout;
    layout_width="fill";
    layout_height="wrap";
    paddingLeft="16dp";
    paddingRight="16dp";
    {
      EditText;
      id="FolderName";
      hint="文件夹名称";
      layout_width="fill";
      layout_height="wrap";
    };
  }))
  .setPositiveButton("确定",{onClick=function(view)
      if FolderName.Text == "" then
        print("不得为空")
       else
        if File(thisPath..FolderName.Text.."/").isDirectory() then
          print("文件夹已存在")
         else
          os.execute("mkdir \""..thisPath..FolderName.Text.."/\"")
          if File(thisPath..FolderName.Text.."/").isDirectory() then
            print("新建成功")
           else
            print("新建失败")
          end
          NoteBackground1.removeView(NoteBackground2)
          加载笔记列表(thisPath)
        end
      end
  end})
  .setNegativeButton("取消",nil)
  .show();
end

function onKeyDown(keycode,event)
  if keycode == 4 then
    if thisPath ~= pathn then
      NoteBackground1.removeView(NoteBackground2)
      加载笔记列表(tostring(File(thisPath).getParentFile()).."/")
     else
      activity.finish()
    end
    return true
  end
end

mainTitle.onClick=function(view)
  mainBackground.fullScroll(View.FOCUS_UP)
end

back.onClick=function(view)
  if thisPath ~= pathn then
    NoteBackground1.removeView(NoteBackground2)
    加载笔记列表(tostring(File(thisPath).getParentFile()).."/")
   else
    activity.finish()
  end
end

task(1,function()
  加载笔记列表(pathn)
end)
