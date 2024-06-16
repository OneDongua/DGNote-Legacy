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
        gravity="center";
        id="mainTitle";
        text="回收站";
        textSize="20sp";
        layout_height="fill";
      };
    };
    {
      LinearLayout;
      layout_height="24dp";
      layout_gravity="center|right";
      paddingRight="12dp";
      {
        ImageView;
        id="popmenu";
        src=ICON_MENU;
        layout_width="24dp";
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

水波纹(popmenu)
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
    function anim(view,direction)
      local Y = ObjectAnimator.ofFloat(view.getParent(),"X",{view.getParent().getX(),activity.getWidth()*(direction or 1)})
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

      view.noteBg.onClick=function(view)
        loadNote(tostring(data[position+1].path))
      end
      view.noteBg.onLongClick=function(view)
        local oriPath=data[position+1].path
        local pop=PopupMenu(activity,view)
        local menu=pop.Menu
        menu.add("恢复").onMenuItemClick=function(a)
          local restorePath=tostring(oriPath):gsub(pathr,pathn)
          if File(restorePath).isDirectory() then
            local dialog=AlertDialog.Builder(this)
            dialog.setTitle("是否覆盖")
            dialog.setMessage("已存在相同文件夹")
            dialog.setPositiveButton("确定",{onClick=function(v)
                anim(view,-1)
                os.execute("cp -rf \""..tostring(oriPath).."\" \""..父目录(restorePath).."\"")
                os.execute("rm -rf \""..tostring(oriPath).."\"")
                task(300,function()
                  if oriPath.isDirectory() then
                    print("恢复失败")
                   else
                    print("恢复成功")
                    updateWebdavInfo()
                  end
                  loadNote(thisPath)
                end)
            end})
            dialog.setNegativeButton("取消",nil)
            dialog.show()
           else
            anim(view,-1)
            os.rename(tostring(oriPath),restorePath)
            task(300,function()
              if File(tostring(oriPath)).isDirectory() then
                print("恢复失败")
               else
                print("恢复成功")
                updateWebdavInfo()
              end
              loadNote(thisPath)
            end)
          end
        end
        menu.add("删除").onMenuItemClick=function()
          local dialog=AlertDialog.Builder(this)
          dialog.setTitle("是否彻底删除？")
          dialog.setMessage("操作将无法撤销")
          dialog.setPositiveButton("确定",{onClick=function(v)
              anim(view)
              os.execute("rm -rf \""..tostring(oriPath).."\"")
              task(300,function()
                if oriPath.isDirectory() then
                  print("删除失败")
                 else
                  print("删除成功")
                end
                loadNote(thisPath)
              end)
          end})
          dialog.setNegativeButton("取消",nil)
          dialog.show()
        end
        pop.show()
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

      view.noteBg.onClick=function(view)
        thisNote={}
        thisNote.path=tostring(data[position+1].path)
        activity.newActivity("view",{thisNote})
      end
      view.noteBg.onLongClick=function(view)
        local oriPath=data[position+1].path
        local pop=PopupMenu(activity,view)
        local menu=pop.Menu
        menu.add("恢复").onMenuItemClick=function()
          local restorePath=tostring(oriPath):gsub(pathr,pathn)
          if File(restorePath).isFile() then
            local dialog=AlertDialog.Builder(this)
            dialog.setTitle("是否覆盖")
            dialog.setMessage("已存在相同标题便签")
            dialog.setPositiveButton("确定",{onClick=function(v)
                anim(view,-1)
                os.rename(tostring(oriPath),restorePath)
                task(300,function()
                  if oriPath.isFile() then
                    print("恢复失败")
                   else
                    print("恢复成功")
                    updateWebdavInfo()
                  end
                  loadNote(thisPath)
                end)
            end})
            dialog.setNegativeButton("取消",nil)
            dialog.show()
           else
            anim(view,-1)
            创建父文件(restorePath)
            os.rename(tostring(oriPath),restorePath)
            task(300,function()
              if oriPath.isFile() then
                print("恢复失败")
               else
                print("恢复成功")
                updateWebdavInfo()
              end
              loadNote(thisPath)
            end)
          end
        end
        menu.add("删除").onMenuItemClick=function(a)
          local dialog=AlertDialog.Builder(this)
          dialog.setTitle("是否彻底删除？")
          dialog.setMessage("操作将无法撤销")
          dialog.setPositiveButton("确定",{onClick=function(v)
              anim(view)
              os.remove(tostring(oriPath))
              task(300,function()
                if oriPath.isFile() then
                  print("删除失败")
                 else
                  print("删除成功")
                end
                loadNote(thisPath)
              end)
          end})
          dialog.setNegativeButton("取消",nil)
          dialog.show()
        end
        menu.add("多选").onMenuItemClick=function(a)
          activity.newActivity("multiselect",{{path=thisPath, from="recycle"}})
        end
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

  if path ~= pathr then
    mainTitle.setText(File(path).getName())
    popmenu.setVisibility(View.GONE)
   else
    mainTitle.setText("回收站")
    popmenu.setVisibility(View.VISIBLE)
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
        table.insert(data,{["path"]=v,["title"]=v.getName(),["text"]=text,["date"]=文件修改时间(v),["type"]=1})
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

popmenu.onClick=function(view)
  pop=PopupMenu(activity,popmenu)
  menu=pop.Menu
  menu.add("恢复全部").onMenuItemClick=function()
    dialog=AlertDialog.Builder(this)
    dialog.setTitle("是否恢复全部？")
    dialog.setMessage("将会覆盖同名便签")
    dialog.setPositiveButton("确定",{onClick=function(v)
        os.execute("mv -f "..pathr.."* "..pathn)
        print("已恢复")
        updateWebdavInfo()
        loadNote(pathr)
    end})
    dialog.setNegativeButton("取消",nil)
    dialog.show()
  end
  menu.add("删除全部").onMenuItemClick=function()
    dialog=AlertDialog.Builder(this)
    dialog.setTitle("是否清空回收站？")
    dialog.setMessage("操作将无法撤销")
    dialog.setPositiveButton("确定",{onClick=function(v)
        os.execute("rm -rf "..pathr.."*")
        print("已清空")
        loadNote(pathr)
    end})
    dialog.setNegativeButton("取消",nil)
    dialog.show()
  end
  pop.show()
end

function onKeyDown(keycode,event)
  if keycode == 4 then
    if thisPath ~= pathr then
      loadNote(父目录(thisPath))
     else
      activity.finish()
    end
    return true
  end
end

mainTitle.onClick=function(view)
  mainRecycler.smoothScrollToPosition(0)
end

back.onClick=function(view)
  if thisPath ~= pathr then
    loadNote(父目录(thisPath))
   else
    activity.finish()
  end
end

loadNote(pathr)