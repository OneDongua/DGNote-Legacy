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
    };
    {
      LinearLayout;
      layout_height="24dp";
      layout_gravity="center";
      {
        TextView;
        layout_width="wrap";
        layout_height="fill";
        id="importText";
        textSize="20sp";
        text="导入";
        gravity="center";
      };
      {
        LinearLayout;
        layout_height="0dp";
        layout_width="16dp";
      };
      {
        TextView;
        layout_width="wrap";
        layout_height="fill";
        id="exportText";
        textSize="20sp";
        text="导出";
        gravity="center";
      };
    };
    {
      LinearLayout;
      layout_height="24dp";
      layout_gravity="center|right";
      paddingRight="18dp";
      {
        ImageView;
        id="check";
        src=ICON_CHECK;
        layout_width="24dp";
        layout_height="fill";
      };
    };
  };
  {
    PageView;
    layout_height="fill";
    layout_width="fill";
    id="pageView";
    pages={
      {
        ScrollView;
        id="a_mainBackground";
        layout_width="fill";
        layout_height="fill";
        verticalScrollBarEnabled=false;
        {
          LinearLayout;
          orientation="vertical";
          layout_width="fill";
          layout_height="fill";
          {
            LinearLayout;
            layout_width="fill";
            layout_height="wrap";
            orientation="vertical";
            {
              TextView;
              id="a_category_1";
              layout_width="wrap";
              layout_height="wrap";
              paddingTop="16dp";
              paddingLeft="16dp";
              paddingBottom="4dp";
              textSize="14sp";
              text="导入";
              textColor=COLOR_ACCENT;
            }
          };
          {
            LinearLayout;
            layout_height="wrap";
            layout_width="fill";
            backgroundColor=COLOR_MAIN_BACKGROUND;
            {
              LinearLayout;
              id="a_item_1";
              layout_height="fill";
              layout_width="fill";
              {
                LinearLayout;
                layout_width="fill";
                padding="16dp";
                layout_height="fill";
                orientation="vertical";
                {
                  TextView;
                  id="a_title_1";
                  maxLines="2";
                  text="从文件";
                  textSize="16sp";
                  textColor=COLOR_ON_BACKGROUND;
                };
                {
                  TextView;
                  id="a_text_1";
                  maxLines="3";
                  text="从本地文件导入便签";
                  textSize="14sp";
                };
              };
            };
          };
          {
            LinearLayout;
            layout_height="wrap";
            layout_width="fill";
            backgroundColor=COLOR_MAIN_BACKGROUND;
            {
              LinearLayout;
              id="a_item_2";
              layout_height="fill";
              layout_width="fill";
              {
                LinearLayout;
                layout_width="fill";
                padding="16dp";
                layout_height="fill";
                orientation="vertical";
                {
                  TextView;
                  id="a_title_2";
                  maxLines="2";
                  text="从小米笔记";
                  textSize="16sp";
                  textColor=COLOR_ON_BACKGROUND;
                };
                {
                  TextView;
                  id="a_text_2";
                  maxLines="3";
                  text="从小米笔记导入便签";
                  textSize="14sp";
                };
              };
            };
          };
          {
            LinearLayout;
            layout_width="fill";
            layout_height="wrap";
            orientation="vertical";
            {
              LinearLayout;
              layout_width="fill";
              layout_height="1dp";
              background="#80A0A0A0";
            };
            {
              TextView;
              id="a_category_2";
              layout_width="wrap";
              layout_height="wrap";
              paddingTop="16dp";
              paddingLeft="16dp";
              paddingBottom="4dp";
              textSize="14sp";
              text="设置";
              textColor=COLOR_ACCENT;
            }
          };
          {
            LinearLayout;
            layout_height="wrap";
            layout_width="fill";
            backgroundColor=COLOR_MAIN_BACKGROUND;
            {
              LinearLayout;
              id="a_item_3";
              layout_height="fill";
              layout_width="fill";
              {
                LinearLayout;
                layout_width="fill";
                padding="16dp";
                layout_height="fill";
                Orientation="vertical";
                {
                  TextView;
                  id="a_title_3";
                  maxLines="2";
                  text="清除小米账号状态";
                  textSize="16sp";
                  textColor=COLOR_ON_BACKGROUND;
                };
                {
                  TextView;
                  id="a_text_3";
                  maxLines="3";
                  text="清除Cookies";
                  textSize="14sp";
                };
              };
            };
          };
          {
            LinearLayout;
            layout_height="wrap";
            layout_width="fill";
            backgroundColor=COLOR_MAIN_BACKGROUND;
            {
              FrameLayout;
              id="a_item_4";
              layout_height="fill";
              layout_width="fill";
              {
                LinearLayout;
                layout_width="wrap";
                padding="16dp";
                layout_height="fill";
                Orientation="vertical";
                {
                  TextView;
                  id="a_title_4";
                  maxLines="2";
                  text="自动去除文件扩展名";
                  textSize="16sp";
                  textColor=COLOR_ON_BACKGROUND;
                };
                {
                  TextView;
                  id="a_text_4";
                  maxLines="3";
                  text="设置从本地文件导入时是否自动去除文件扩展名";
                  textSize="14sp";
                };
              };
              {
                LinearLayout;
                layout_height="fill";
                layout_width="wrap";
                layout_gravity="center|right";
                {
                  Switch;
                  id="a_switch_4";
                  layout_height="fill";
                  gravity="center";
                  paddingRight="16dp";
                  clickable=false
                };
              };
            };
          };
          {
            LinearLayout;
            layout_height="wrap";
            layout_width="fill";
            backgroundColor=COLOR_MAIN_BACKGROUND;
            {
              FrameLayout;
              id="a_item_5";
              layout_height="fill";
              layout_width="fill";
              {
                LinearLayout;
                layout_width="wrap";
                padding="16dp";
                layout_height="fill";
                Orientation="vertical";
                {
                  TextView;
                  id="a_title_5";
                  maxLines="2";
                  text="小米便签导入调试模式";
                  textSize="16sp";
                  textColor=COLOR_ON_BACKGROUND;
                };
                {
                  TextView;
                  id="a_text_5";
                  maxLines="3";
                  text="不会去除html格式";
                  textSize="14sp";
                };
              };
              {
                LinearLayout;
                layout_height="fill";
                layout_width="wrap";
                layout_gravity="center|right";
                {
                  CheckBox;
                  id="a_checkbox_5";
                  layout_height="fill";
                  gravity="center";
                  paddingRight="16dp";
                  clickable=false
                };
              };
            };
          };
          {
            LinearLayout;
            layout_height="wrap";
            layout_width="fill";
            backgroundColor=COLOR_MAIN_BACKGROUND;
            {
              FrameLayout;
              id="a_item_6";
              layout_height="fill";
              layout_width="fill";
              {
                LinearLayout;
                layout_width="wrap";
                padding="16dp";
                layout_height="fill";
                Orientation="vertical";
                {
                  TextView;
                  id="a_title_6";
                  maxLines="2";
                  text="自动去除文件扩展名实验性功能";
                  textSize="16sp";
                  textColor=COLOR_ON_BACKGROUND;
                };
                {
                  TextView;
                  id="a_text_6";
                  maxLines="3";
                  text="可去除其他不受支持的扩展名";
                  textSize="14sp";
                };
              };
              {
                LinearLayout;
                layout_height="fill";
                layout_width="wrap";
                layout_gravity="center|right";
                {
                  CheckBox;
                  id="a_checkbox_6";
                  layout_height="fill";
                  gravity="center";
                  paddingRight="16dp";
                  clickable=false
                };
              };
            };
          };
        };
      };
      {
        FrameLayout;
        layout_width="fill";
        layout_height="fill";
        id="b_mainBackground";
        {
          TextView;
          id="b_empty";
          text="空";
          layout_width="fill";
          layout_height="100%w";
          gravity="center";
        };
        {
          RecyclerView;
          id="b_recycler";
          layout_width="fill";
          layout_height="wrap";
        };
      };
    };
  };
}

设置视图(layout2)

水波纹(importText)
水波纹(exportText)
水波纹(back)
水波纹(check)

importText.onClick=function()
  pageView.showPage(0)
end
exportText.onClick=function()
  pageView.showPage(1)
end

font=sharedData.font
pageView.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageScrolled=function(position,positionOffset,positionOffsetPixels)
    if font=="无" or font==nil then
      if positionOffset==0 then
        if position==0 then
          importText.setTypeface(Typeface.DEFAULT_BOLD)
          exportText.setTypeface(Typeface.DEFAULT)
          check.setVisibility(View.GONE)
          pages=1
         elseif position==1 then
          exportText.setTypeface(Typeface.DEFAULT_BOLD)
          importText.setTypeface(Typeface.DEFAULT)
          check.setVisibility(View.VISIBLE)
          pages=2
        end
       elseif positionOffset<0.45 then
        importText.setTypeface(Typeface.DEFAULT_BOLD)
        exportText.setTypeface(Typeface.DEFAULT)
        check.setVisibility(View.GONE)
       elseif positionOffset>0.55 then
        exportText.setTypeface(Typeface.DEFAULT_BOLD)
        importText.setTypeface(Typeface.DEFAULT)
        check.setVisibility(View.VISIBLE)
       else
        importText.setTypeface(Typeface.DEFAULT_BOLD)
        exportText.setTypeface(Typeface.DEFAULT_BOLD)
        check.setVisibility(View.GONE)
      end
     else
      if positionOffset==0 then
        if position==0 then
          importText.getPaint().setFakeBoldText(true)
          exportText.getPaint().setFakeBoldText(false)
          设置字体(importText)
          设置字体(exportText)
          check.setVisibility(View.GONE)
          pages=1
         elseif position==1 then
          exportText.getPaint().setFakeBoldText(true)
          importText.getPaint().setFakeBoldText(false)
          设置字体(importText)
          设置字体(exportText)
          check.setVisibility(View.VISIBLE)
          pages=2
        end
      end
    end
  end
})

mainActionBar.setBackgroundColor(COLOR_MAIN)
importText.setTextColor(COLOR_ON_MAIN)
exportText.setTextColor(COLOR_ON_MAIN)
a_mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
b_mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)

function loada()
  a_category_1.getPaint().setFakeBoldText(true)
  设置字体(a_category_1)

  设置字体(a_title_1)
  设置字体(a_text_1)
  水波纹(a_item_1)
  a_item_1.onClick=function(view)
    ext={".zip"}
    activity.setSharedData("selected",nil)
    activity.newActivity("chooseFile",{ext})
    function onResume()
      local filePath = activity.getSharedData("selected")
      if filePath then
        AlertDialog.Builder(this)
        .setTitle("是否导入？")
        .setMessage("文件路径："..filePath)
        .setPositiveButton("确定",{onClick=function(v)
            local importTempPath = patht.."import/"
            os.execute("rm -rf \""..importTempPath.."\"")
            创建文件夹(importTempPath)
            LuaUtil.unZip(filePath, importTempPath)
            local ls=luajava.astable(File(importTempPath).listFiles())
            local r1
            local r2
            for k, f in pairs(ls) do
              local name = f.getName()
              switch name
               case "MetaData.json"
                r1 = true
               case "note"
                r2 = true
              end
            end

            function importing(importingPath)
              local ls=luajava.astable(File(importingPath).listFiles())
              for k,f in pairs(ls) do
                if f.isFile() then
                  local name=f.getName()
                  local p=tostring(f)
                  if activity.getSharedData("importDelExtDebug")~=true then
                    local ext={".txt",".md",".markdown",".html",".htm"}
                    for k,e in ipairs(ext) do
                      if name:match(e)~=nil then
                        e=e:gsub("%.","")
                        os.rename(p,p:gsub("%."..e,""))
                      end
                    end
                   else
                    local e=name:match(".+%.(%w+)$")
                    if e~=nil then
                      os.rename(p,p:gsub("%."..e,""))
                    end
                  end
                 elseif f.isDirectory() then
                  importing(tostring(f))
                end
              end
            end

            if r1 and r2 then
              local oldTree = cjson.decode(读取文件(pathc.."MetaData.json"))
              local newTree = cjson.decode(读取文件(importTempPath.."MetaData.json"))
              local merged = mergeTrees(oldTree, newTree)
              写入文件(pathc.."MetaData.json", cjson.encode(merged))
              os.execute("mv -f "..importTempPath.."note/* "..pathn)
              updateWebdavInfoOnly()
             else
              if activity.getSharedData("importDelExt") then
                importing(importTempPath)
              end
              os.execute("mv -f "..importTempPath.."* "..pathn)
              updateWebdavInfo()
            end
            print("导入成功")
            os.execute("rm -rf \""..importTempPath.."\"")
            activity.finish()
        end})
        .setNegativeButton("取消",nil)
        .show()

        activity.setSharedData("selected", nil)
      end
    end
  end

  设置字体(a_title_2)
  设置字体(a_text_2)
  水波纹(a_item_2)
  a_item_2.onClick=function(view)
    activity.newActivity("importfromMi")
  end

  a_category_2.getPaint().setFakeBoldText(true)
  设置字体(a_category_2)

  设置字体(a_title_3)
  设置字体(a_text_3)
  水波纹(a_item_3)
  a_item_3.onClick=function(view)
    CookieManager.getInstance().removeAllCookie()
    print("清除成功")
  end

  设置字体(a_title_4)
  设置字体(a_text_4)
  水波纹(a_item_4)
  if activity.getSharedData("importDelExt")==nil then
    a_switch_4.setChecked(false)
   else
    a_switch_4.setChecked(activity.getSharedData("importDelExt"))
  end
  a_item_4.onClick=function(view)
    if a_switch_4.isChecked() then
      a_switch_4.setChecked(false)
      activity.setSharedData("importDelExt",false)
     else
      a_switch_4.setChecked(true)
      activity.setSharedData("importDelExt",true)
    end
  end

  设置字体(a_title_5)
  设置字体(a_text_5)
  水波纹(a_item_5)
  if activity.getSharedData("importDebug")==nil then
    a_checkbox_5.setChecked(false)
   else
    a_checkbox_5.setChecked(activity.getSharedData("importDebug"))
  end
  a_item_5.onClick=function(view)
    if a_checkbox_5.isChecked() then
      a_checkbox_5.setChecked(false)
      activity.setSharedData("importDebug",false)
     else
      a_checkbox_5.setChecked(true)
      activity.setSharedData("importDebug",true)
    end
  end

  设置字体(a_title_6)
  设置字体(a_text_6)
  水波纹(a_item_6)
  if activity.getSharedData("importDelExtDebug")==nil then
    a_checkbox_6.setChecked(false)
   else
    a_checkbox_6.setChecked(activity.getSharedData("importDelExtDebug"))
  end
  a_item_6.onClick=function(view)
    if a_checkbox_6.isChecked() then
      a_checkbox_6.setChecked(false)
      activity.setSharedData("importDelExtDebug",false)
     else
      a_checkbox_6.setChecked(true)
      activity.setSharedData("importDelExtDebug",true)
    end
  end
  if activity.getSharedData("devmode") ~= true then
    a_item_5.setVisibility(View.GONE)
    a_item_6.setVisibility(View.GONE)
  end
end

function loadb()
  function b_loadFile(path)
    b_path=path

    local ls=luajava.astable(File(path).listFiles())
    b_data={}
    if next(ls)~=nil then
      sort(ls, 1)
      for k,v in ipairs(ls) do
        if v.isDirectory() then
          table.insert(b_data,{path=v, title=v.getName()})
        end
      end
      b_empty.setVisibility(View.GONE)
     else
      b_empty.setVisibility(View.VISIBLE)
    end
    b_adapter.notifyDataSetChanged()

  end

  b_adapter = LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return #b_data
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
      local view=holder.view.getTag()
      view.noteTitle.Text=b_data[position+1].title.."/"

      view.noteCard.setBackgroundColor(COLOR_CARD_BACKGROUND)
      view.noteTitle.setTextColor(COLOR_ON_BACKGROUND)
      view.noteTitle.getPaint().setFakeBoldText(false)

      设置字体(view.noteTitle)

      水波纹(view.noteBg)

      view.noteBg.onClick=function(view)
        b_loadFile(tostring(b_data[position+1].path).."/")
      end

    end
  }))

  b_recycler.setAdapter(b_adapter)
  b_recycler.setLayoutManager(LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false))

  b_loadFile(sdPath)

  function onResume()
    b_loadFile(b_path)
  end

  check.onClick=function()
    local exportTempPath = patht.."export/"
    os.execute("rm -rf \""..exportTempPath.."\"")
    创建文件夹(exportTempPath)
    os.execute("cp -rf \""..pathn.."\" \""..exportTempPath.."\"")
    os.execute("cp -rf \""..pathc.."MetaData.json\" \""..exportTempPath.."\"")
    local from = exportTempPath
    local to = b_path
    local name = "DgNote-"..os.date("%Y-%m-%d-%H-%M-%S")..".zip"
    LuaUtil.zip(from, to, name)
    if File(b_path..name).isFile() then
      print("导出成功")
      os.execute("rm -rf \""..exportTempPath.."\"")
      activity.finish()
     else
      print("导出失败")
    end
  end
end

back.onClick=function(view)
  if pages==1 then
    activity.finish()
   elseif pages==2 then
    if b_path ~= sdPath then
      b_loadFile(父目录(b_path))
     else
      activity.finish()
    end
  end
end

function onKeyDown(keycode,event)
  if keycode == 4 then
    if pages==1 then
      activity.finish()
     elseif pages==2 then
      if b_path ~= sdPath then
        b_loadFile(父目录(b_path))
       else
        activity.finish()
      end
    end
  end
  return true
end

loada()
loadb()
