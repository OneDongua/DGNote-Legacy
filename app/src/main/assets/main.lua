require "import"
import "mod"
import "color"

if File(pathn).isDirectory()~=true then
  创建文件夹(pathn)
end
if File(pathr).isDirectory()~=true then
  创建文件夹(pathr)
end
if File(patht).isDirectory()~=true then
  创建文件夹(patht)
end
if File(pathb).isDirectory()~=true then
  创建文件夹(pathb)
end
if File(pathh).isDirectory()~=true then
  创建文件夹(pathh)
end
if File(pathf).isDirectory()~=true then
  创建文件夹(pathf)
end
if File(notePicPath).isDirectory()~=true then
  创建文件夹(notePicPath)
  创建文件(notePicPath..".nomedia")
end

--[[if sharedData.stopGettingIP == false then
  --获取ip信息
  local ipURL = "https://ip.useragentinfo.com/json"
  Http.get(ipURL, nil, "utf8", nil, function(code, content, cookie, header)
    if code == 200 then
      写入文件(pathc.."LastIPInfo.json", content)
    end
  end)
end]]

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
        text="加载中";
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
        id="popmenu";
        src=ICON_MENU;
        layout_width="24dp";
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
      CardView;
      layout_width="56dp";
      layout_height="56dp";
      layout_marginRight="24dp";
      layout_marginBottom="56dp";
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
      SwipeRefreshLayout;
      id="pulling";
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
          text="点击+创建第一条便签\n(长按创建文件夹)";
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
  };
}


设置视图(layout2)

水波纹(back)
水波纹(popmenu)
水波纹(add)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
fab.setBackgroundColor(COLOR_MAIN)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
back.setVisibility(View.GONE)

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
      view.noteTitle.setVisibility(View.VISIBLE)
      view.noteText.setVisibility(View.GONE)
      view.noteDate.setVisibility(View.GONE)

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(true)

      设置字体(view.noteTitle)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        loadNote(tostring(oriPath).."/")
      end
      view.noteBg.onLongClick=function(view)
        local pop=PopupMenu(activity,view)
        local menu=pop.Menu
        menu.add("删除").onMenuItemClick=function()
          local delPath=tostring(oriPath):gsub(pathn,pathr)
          if File(delPath).isDirectory() then
            local dialog=AlertDialog.Builder(this)
            dialog.setTitle("是否覆盖？")
            dialog.setMessage("回收站已存在相同文件夹")
            dialog.setPositiveButton("确定",{onClick=function(v)
                anim(view)
                os.execute("cp -rf \""..tostring(oriPath).."\" \""..父目录(delPath).."\"")
                os.execute("rm -rf \""..tostring(oriPath).."\"")
                task(300,function()
                  if oriPath.isDirectory() then
                    print("删除失败")
                   else
                    print("删除成功")
                    updateWebdavInfo()
                  end
                  loadNote(thisPath)
                end)
            end})
            dialog.setNegativeButton("取消",nil)
            dialog.show()
           else
            anim(view)
            创建父文件(delPath)
            os.rename(tostring(oriPath),delPath)
            task(300,function()
              if oriPath.isDirectory() then
                print("删除失败")
               else
                print("删除成功")
                updateWebdavInfo()
              end
              loadNote(thisPath)
            end)
          end
        end
        menu.add("重命名").onMenuItemClick=function()
          AlertDialog.Builder()
          .setTitle("重命名")
          .setView(loadlayout({
            LinearLayout;
            layout_width="fill";
            layout_height="wrap";
            paddingLeft="16dp";
            paddingRight="16dp";
            {
              EditText;
              id="name";
              hint="文件夹名称";
              layout_width="fill";
              layout_height="wrap";
              selectAllOnFocus=true
            };
          }))
          .setPositiveButton("确定",{onClick=function(view)
              if name.Text == "" then
                print("不得为空")
               else
                if File(thisPath..name.Text.."/").isDirectory() then
                  print("文件夹已存在")
                 else
                  os.rename(tostring(oriPath).."/",thisPath..name.Text)
                  if File(thisPath..name.Text).isDirectory() then
                    print("重命名成功")
                    updateWebdavInfo()
                  end
                  loadNote(thisPath)
                end
              end
          end})
          .setNegativeButton("取消",nil)
          .show();
          name.setText(oriPath.getName())
        end
        menu.add("移动").onMenuItemClick=function(a)
          activity.newActivity("move",{tostring(oriPath)})
        end
        pop.show()
      end
     elseif data[position+1].type==1 then
      if sharedData.hideTimeTitle ~= true then
        view.noteTitle.setVisibility(View.VISIBLE)
        view.noteTitle.Text=data[position+1].title
       else
        if data[position+1].title:match("%d+%-%d+%-%d+ %d+%-%d+%-%d+")
          and data[position+1].text ~= "" then
          view.noteTitle.setVisibility(View.GONE)
         else
          view.noteTitle.setVisibility(View.VISIBLE)
          view.noteTitle.Text=data[position+1].title
        end
      end
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

      view.noteText.setMaxLines(data[position+1].maxLines)

      设置字体(view.noteTitle)
      设置字体(view.noteText)
      设置字体(view.noteDate)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        thisNote={}
        thisNote.path=tostring(oriPath)
        activity.newActivity("amend",{thisNote})
      end
      view.noteBg.onLongClick=function(view)
        local pop=PopupMenu(activity,view)
        local menu=pop.Menu
        menu.add("删除").onMenuItemClick=function(a)
          local delPath=tostring(oriPath):gsub(pathn,pathr)
          if File(delPath).isFile() then
            local dialog=AlertDialog.Builder(this)
            dialog.setTitle("是否覆盖")
            dialog.setMessage("回收站已存在相同标题便签")
            dialog.setPositiveButton("确定",{onClick=function(v)
                anim(view)
                os.rename(tostring(oriPath),delPath)
                task(300,function()
                  if oriPath.isFile() then
                    print("删除失败")
                   else
                    print("删除成功")
                    updateWebdavInfo()
                  end
                  loadNote(thisPath)
                end)
            end})
            dialog.setNegativeButton("取消",nil)
            dialog.show()
           else
            anim(view)
            创建父文件(delPath)
            os.rename(tostring(oriPath),delPath)
            task(300,function()
              if oriPath.isFile() then
                print("删除失败")
               else
                print("删除成功")
                updateWebdavInfo()
              end
              loadNote(thisPath)
            end)
          end
        end
        menu.add("移动").onMenuItemClick=function(a)
          activity.newActivity("move", {tostring(oriPath)})
        end
        menu.add("多选").onMenuItemClick=function(a)
          activity.newActivity("multiselect", {{path=thisPath, from="main"}})
        end
        --[[menu.add("置顶").onMenuItemClick=function(a)
          
        end]]
        pop.show()
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

  if path ~= pathn then
    mainTitle.setText(File(path).getName())
    back.setVisibility(View.VISIBLE)
   else
    mainTitle.setText("便签")
    back.setVisibility(View.GONE)
  end

  ls=luajava.astable(File(path).listFiles())
  data={}
  if next(ls) ~= nil then
    sort(ls)
    for k,v in ipairs(ls) do
      if v.isDirectory() then
        table.insert(data, {path=v,title=v.getName(),type=0})
       elseif v.isFile() then
        local fullText = 读取文件(v)
        local maxLines
        local _, lines1 = fullText:gsub("\n", "")
        local lines2 = math.floor(String(fullText).length() / 50)
        if lines1 == 0 then
          maxLines = 5
         elseif lines1 > 15 and lines2 > 15 then
          maxLines = 15
         else
          if lines1 > lines2 then
            maxLines = lines2 + 3
           else
            maxLines = lines1 + 3
          end
        end
        local text
        if String(fullText).length() > 200 then
          text = String(fullText).substring(0, 200).."…"
         else
          text = fullText
        end
        table.insert(data, {path=v,title=v.getName(),text=text,date=文件修改时间(v),type=1,maxLines=maxLines})
        fullText = nil
        text = nil
      end
    end
    emptyText.setVisibility(View.GONE)
   else
    emptyText.setVisibility(View.VISIBLE)
  end
  adapter.notifyDataSetChanged()
end

mainRecycler.addOnScrollListener(
RecyclerView.OnScrollListener{
  onScrollStateChanged=function(view,newState)
    if newState==view.SCROLL_STATE_IDLE then
      --[[local manager=view.getLayoutManager()
      --第一个完整的
      --mainRecyclercompletelyPos=luajava.astable(manager.findFirstCompletelyVisibleItemPositions(nil))[1]
      --第一个可见的
      local child=manager.getChildAt(0)
      if child then
        mainRecyclerPos=manager.getPosition(child)
      end]]

      if sharedData.webdavStatu == true then
        if view.canScrollVertically(-1) then
          pulling.setEnabled(false)
         else
          pulling.setEnabled(true)
        end
      end
    end
  end
})

function onResume()
  if activity.getSharedData("change") == true then
    activity.setSharedData("change", false)
    refreshSharedData()
    activity.recreate()
   else
    loadNote(thisPath)
  end
end

mainTitle.onClick=function(view)
  mainRecycler.smoothScrollToPosition(0)
end

back.onClick=function(view)
  loadNote(父目录(thisPath))
end

popmenu.onClick=function(view)
  local pop=PopupMenu(activity,popmenu)
  local menu=pop.Menu
  menu.add("搜索").onMenuItemClick=function()
    thisNote={}
    thisNote.parentPath=thisPath
    activity.newActivity("search",{thisNote})
  end
  menu.add("回收站").onMenuItemClick=function()
    activity.newActivity("recycle")
  end
  menu.add("设置").onMenuItemClick=function()
    activity.newActivity("setting")
  end
  menu.add("关于").onMenuItemClick=function()
    activity.newActivity("about")
  end
  pop.show()
end

add.onClick=function(view)
  local time=os.date("%Y-%m-%d %H-%M-%S")
  local newNotePath=thisPath..time
  local thisNote={}
  thisNote.path=newNotePath
  thisNote.time=time
  创建文件(newNotePath)
  activity.newActivity("amend",{thisNote})
end
add.onLongClick=function(view)
  local dialog = AlertDialog.Builder(this)
  .setTitle("创建文件夹")
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
      if FolderName.text:find("[/\\:*?<>\"]") then
        print("标题存在非法字符")
        return
      end
      if FolderName.Text == "" then
        print("不得为空")
       else
        if File(thisPath..FolderName.Text.."/").isDirectory() then
          print("文件夹已存在")
         else
          os.execute("mkdir \""..thisPath..FolderName.Text.."/\"")
          if File(thisPath..FolderName.Text.."/").isDirectory() then
            print("新建成功")
            updateWebdavInfo()
           else
            print("新建失败")
          end
          loadNote(thisPath)
        end
      end
  end})
  .setNegativeButton("取消",nil)
  .show()
end


loadNote(pathn)
update()

function sync(exit)
  if getNetworkInfo() then
    syncing = true
    autoExit = exit
    mainTitle.setText("同步中…")
    activity.startService("webdav/mainSyncService",nil)
   else
    print("无网络连接")
    pulling.setRefreshing(false)
  end
end

--注册广播接收器
import "android.content.BroadcastReceiver"
import "android.content.IntentFilter"
serviceReceiver = BroadcastReceiver{
  onReceive=function(context, intent)
    syncing=false
    pulling.setRefreshing(false)

    if thisPath ~= pathn then
      mainTitle.setText(File(thisPath).getName())
     else
      mainTitle.setText("便签")
    end

    local cache_info=patht.."WebdavInfo.json"
    local last_info=pathc.."LastWebdavInfo.json"

    local res=intent.getExtra("result")
    local function refresh()
      loadNote(thisPath)
      print("同步成功"..tostring(res))
    end

    if type(res) == "number" then
      if res >= 100 then
        print("同步：迁移成功")
        res = res-100
      end
    end
    switch(res)
     case nil
      print("同步错误：未知错误")
     case 0
      print("同步错误0：未执行任何操作")
     case 1
      refresh()
     case 2
      refresh()
     case 3
      print("同步：无需操作")
     case 4
      print("同步错误4：配置文件不存在")
     case 5
      refresh()
     case 6
      refresh()
     default
      print(res)
    end

    activity.stopService()

    写入文件(pathc.."LastSyncResult.log", tostring(res))
    if autoExit then
      activity.finish()
    end
  end
}
filter = IntentFilter().addAction("com.onedongua.note.sync")
activity.registerReceiver(serviceReceiver, filter)

function onDestroy()
  local success, err = pcall(function()
    activity.unregisterReceiver(serviceReceiver)
  end)
end

function returnHome()
  local home = Intent(Intent.ACTION_MAIN)
  --home.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP) --回到主界面
  home.addCategory(Intent.CATEGORY_HOME)
  activity.startActivity(home)
end

if sharedData.autoSync then
  task(1, function()
    sync()
  end)
end

backKey = 0
function onKeyDown(keycode, event)
  if keycode == 4 then
    if thisPath ~= pathn then
      loadNote(父目录(thisPath))
     else
      if sharedData.autoSync and sharedData.webdavStatu then
        sync(true)
        returnHome()
       else
        if backKey + 2 > tonumber(os.time()) then
          if syncing ~= true then
            activity.finish()
           else
            returnHome()
          end
         else
          print("再次操作退出便签")
          backKey = tonumber(os.time())
        end
      end
    end
    return true
  end
end

task(function()
  import "libs/util"
  delOldRecycle()
  delOldBak()
end)

if sharedData.webdavStatu ~= true then
  pulling.setEnabled(false)
 else
  pulling.setEnabled(true)
end

pulling.setColorSchemeColors({COLOR_MAIN})
.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{
  onRefresh=function()
    if sharedData.webdavStatu~=true then
      print("未开启同步功能")
      pulling.setRefreshing(false)
     else
      sync()
    end
  end
})

task(1, function()
  if not File(pathc.."MetaData.json").isFile() then
    local pd = ProgressDialog(this)
    pd.setMessage("升级中…")
    --pd.setCancelable(false)
    pd.show()
    local success, err = pcall(function()
      local tree = createTree(File(pathn))
      写入文件(pathc.."MetaData.json", cjson.encode(tree))
    end)
    if success then
      pd.cancel()
     else
      print(err)
    end
   else
    local pd = ProgressDialog(this)
    pd.setMessage("更新中…")
    --pd.setCancelable(false)
    pd.show()
    local success, err = pcall(function()
      updateMetaData(pathc.."MetaData.json", pathn, new)
    end)
    if success then
      pd.cancel()
     else
      print(err)
    end
  end

  local verPath = pathc.."LastVersion"
  local lastVer = 0
  if File(verPath).isFile() then
    lastVer = tonumber(读取文件(verPath))
   else
    写入文件(verPath, tostring(verc))
  end
  --[[if lastVer < 2260 then
    local dialog = AlertDialog.Builder(this)
    dialog.setTitle("使用须知")
    dialog.setMessage("本软件将在使用过程中获取您的IP地址，并可能将其上传到您设置的Webdav同步网盘中，是否允许")
    dialog.setCancelable(false)
    dialog.setPositiveButton("允许", {onClick = function()
        activity.setSharedData("stopGettingIP", false)
    end})
    dialog.setNegativeButton("不允许", {onClick = function()
        activity.setSharedData("stopGettingIP", true)
        os.remove(pathc.."LastIPInfo.json")
    end})
    dialog.show()
  end]]
end)

