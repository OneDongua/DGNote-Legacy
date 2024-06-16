require "import"
import "mod"
import "color"

function onCreate()
  --修复Webview多进程崩溃问题
  function getProcessName(context)
    if context then
      local manager = context.getSystemService(Context.ACTIVITY_SERVICE)
      local processes = luajava.astable(manager.getRunningAppProcesses())
      for k, processInfo in ipairs(processes) do
        local process = luajava.bindClass("android.os.Process")
        if processInfo.pid == process.myPid() then
          return processInfo.processName
        end
      end
    end
  end
  function setWebDataSuffixPath(context)
    if Build.VERSION.SDK_INT >= 28 then
      local processName = getProcessName(context)
      if processName ~= packageName then
        WebView.setDataDirectorySuffix(processName)
      end
    end
  end

  setWebDataSuffixPath(this)
end

layout2={
  LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  id="mainBackground";
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
        text="导入";
        textSize="20sp";
        layout_height="fill";
      };
    };
    {
      LinearLayout;
      layout_height="24dp";
      layout_gravity="center|right";
      paddingRight="18dp";
      {
        ImageView;
        id="refresh";
        src=ICON_REFRESH;
        layout_width="24dp";
        layout_height="fill";
      };
    };
  };
  {
    LuaWebView;
    layout_height="fill";
    layout_width="fill";
    id="webView";
  };
};

设置视图(layout2)

水波纹(back)
水波纹(refresh)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainTitle.setTextColor(COLOR_ON_MAIN)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
mainBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)

webView.loadUrl("https://i.mi.com/note/h5#/")

function start()
  cookie=CookieManager.getInstance().getCookie("https://i.mi.com/note/h5#/")

  noteurl={}
  Http.get("https://i.mi.com/note/full/page/",cookie,"utf8",nil,function(code,content,cookie,header)
    if(code==200 and content)then
      json = cjson.decode(content);
      if json["code"]==0 then
        entries = json["data"]["entries"]
        for k,v in ipairs(entries) do
          id = v.id
          table.insert(noteurl,tostring("https://i.mi.com/note/note/"..id))
        end
      end
     else
      success=false
      print("步骤1失败"..code)
    end
  end)

  task(500,function()
    for k,v in ipairs(noteurl) do
      Http.get(v,cookie,"utf8",nil,function(code,content,cookie,header)
        if(code==200 and content)then
          notejson = cjson.decode(content);
          note=notejson["data"]["entry"]["content"]
          if sharedData.importdebug~=true then
            _, c = note:gsub("☺ .-\n","")
            for i=1,c do
              img=note:match("☺ (.-)\n")
              imgurl="https://i.mi.com/file/full?type=note_img&fileid="..img
              note=string.gsub(note,"☺ .-\n","\n[图片]("..imgurl..")\n",1)
            end
            _, c2 = note:gsub("<.->","")
            if c2>0 then
              note=string.gsub(note,"<.->","",c2)
            end
          end
          _, c3 = note:gsub("&amp;","")
          if c3>0 then
            note=string.gsub(note,"&amp;","&",c3)
          end
          _, c4 = note:gsub("&lt;","")
          if c4>0 then
            note=string.gsub(note,"&lt;","<",c4)
          end
          _, c5 = note:gsub("&gt;","")
          if c5>0 then
            note=string.gsub(note,"&gt;",">",c5)
          end
          extraInfo=notejson["data"]["entry"]["extraInfo"]
          if extraInfo:find("title") then
            title=extraInfo:match("\"title\":\"(.-)\"")
            if title~="" then
              写入文件(pathn..title,note)
             else
              写入文件(pathn.."无标题"..k,note)
            end
           else
            写入文件(pathn.."无标题"..k,note)
          end
         else
          success=false
          print("步骤2失败"..code)
        end
      end)
    end
    if success~=false then
      print("成功")
      activity.finish()
    end
  end)
end

jumping=false
webView.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)
    jumping=true
    if url=="https://i.mi.com/note/h5#/" then
      start()
    end
  end;
}
task(2000,function()
  if jumping==false then
    start()
  end
end)

refresh.onClick=function()
  activity.finish()
  activity.newActivity("importfromMi")
end

back.onClick=function(view)
  activity.finish()
end