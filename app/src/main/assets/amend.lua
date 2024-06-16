require "import"
import "mod"
import "color"
import "libs/regMatch"

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
  id="mainLayout";
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
        text="加载中";
        textSize="20sp";
        layout_height="fill";
      };
    };
    {
      LinearLayout;
      layout_height="24dp";
      layout_gravity="center";
      {
        ImageView;
        id="undo";
        src=ICON_UNDO;
        layout_width="24dp";
        layout_height="fill";
      };
      {
        LinearLayout;
        layout_height="0dp";
        layout_width="18dp";
      };
      {
        ImageView;
        id="redo";
        src=ICON_REDO;
        layout_width="24dp";
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
        id="delete";
        src=ICON_DELETE;
        layout_width="24dp";
        layout_height="fill";
      };
      {
        LinearLayout;
        layout_height="0dp";
        layout_width="18dp";
      };
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
    layout_height="fill";
    layout_width="fill";
    {
      LinearLayout;
      layout_height="fill";
      layout_width="fill";
      id="mainBackground";
      {
        ScrollView;
        layout_height="fill";
        layout_width="fill";
        layout_weight=0;
        VerticalScrollBarEnabled=false;
        id="NoteBackground";
        {
          LinearLayout;
          layout_width="fill";
          layout_height="fill";
          orientation="vertical";
          {
            LinearLayout;
            id="NoteBackground1";
            layout_width="fill";
            layout_height="fill";
            orientation="vertical";
            padding="12dp";
            paddingTop="4dp";
            {
              EditText;
              backgroundColor="#00000000";
              id="NoteTitle";
              hint="标题";
              layout_width="fill";
              layout_height="wrap";
              gravity="start";
              textSize="24sp";
            };
            {
              EditText;
              backgroundColor="#00000000";
              id="NoteText";
              hint="正文";
              layout_width="fill";
              layout_height="fill";
              gravity="start";
              textSize="16sp";
              minHeight="35%h";
            };
            {
              TextView;
              id="wordNumber";
              text="x个字";
              textSize="11sp";
              gravity="right";
              layout_width="fill";
              layout_height="wrap";
            };
            {
              TextView;
              id="date";
              textSize="11sp";
              gravity="right";
              layout_width="fill";
              layout_height="wrap";
            };
          };
          {
            LinearLayout;
            layout_height="48dp";
          };
        };
      };
      {
        LuaWebView;
        layout_height="fill";
        layout_width="fill";
        layout_weight=1;
        id="webView";
      };
    };
    {
      CardView;
      id="bottomBar";
      layout_height="wrap";
      layout_width="fill";
      layout_gravity="bottom";
      layout_margin="12dp";
      radius="12dp";
      elevation="2";
      {
        RecyclerView;
        id="bottomBarRecycler";
        layout_height="fill";
        layout_width="fill";
      };
    };
  };
}


data=...
path=data["path"]
parentPath=父目录(path)
createTime=data["time"]
ishelp=data["ishelp"]

import "org.commonmark.node.Node"
import "org.commonmark.parser.Parser"
import "org.commonmark.renderer.html.HtmlRenderer"
import "org.commonmark.ext.gfm.tables.TablesExtension"
import "org.commonmark.ext.gfm.strikethrough.StrikethroughExtension"
import "org.commonmark.ext.task.list.items.TaskListItemsExtension"
function markdown()
  local tableExtension=Collections.singleton(TablesExtension.create())
  local strikethroughExtension=Collections.singleton(StrikethroughExtension.create())
  local taskListItemsExtension=Collections.singleton(TaskListItemsExtension.create())
  local parser=Parser.builder()
  .extensions(tableExtension)
  .extensions(strikethroughExtension)
  .extensions(taskListItemsExtension)
  .build()
  local note=NoteText.Text
  local note=note:gsub("\n%[浏览%]","")

  local document=parser.parse("# "..NoteTitle.Text.."  \n"..note)
  local renderer=HtmlRenderer.builder()
  .extensions(tableExtension)
  .extensions(strikethroughExtension)
  .extensions(taskListItemsExtension)
  .build()
  local md=html美化(renderer.render(document))
  写入文件(patht.."md.html", md)
end

function loadingMD()
  if sharedData.closemarkdown ~= true then
    markdown()
    webView.loadUrl(patht.."md.html")
    webView.setWebViewClient{
      onPageFinished=function(view, url)
        if url==("file://"..patht.."md.html") then
          --webView.getSettings().setBuiltInZoomControls(false)
          webView.getSettings().setSupportZoom(false)
         else
          --webView.getSettings().setBuiltInZoomControls(true)
          webView.getSettings().setSupportZoom(true)
        end
    end}
  end
end

function save()
  if NoteTitle.text:find("[/\\:*?<>\"]") then
    print("标题存在非法字符")
    return false
  end
  if createTime and NoteTitle.Text == "" and NoteText.Text == "" and forcesave == nil then
    os.remove(path)
    activity.finish()
    return true
  end
  if NoteTitle.Text == File(path).getName() and NoteText.Text == 读取文件(path) then
    activity.finish()
    return true
  end
  if NoteTitle.Text == "" then
    NoteTitle.setText(os.date("%Y-%m-%d %H-%M-%S"))
  end
  if path ~= parentPath..NoteTitle.Text then
    if File(parentPath..NoteTitle.Text).exists() then
      print("当前标题已存在")
      return false
    end
  end

  os.remove(path)
  写入文件(parentPath..NoteTitle.Text,NoteText.Text)
  if File(parentPath..NoteTitle.Text).isFile() then
    activity.finish()
    updateWebdavInfo(parentPath..NoteTitle.Text)
    return true
   else
    print("保存失败")
    return false
  end
end

设置视图(layout2)

mainActionBar.setBackgroundColor(COLOR_MAIN)
mainTitle.setTextColor(COLOR_ON_MAIN)
NoteBackground.setBackgroundColor(COLOR_MAIN_BACKGROUND)
webView.setBackgroundColor(COLOR_MAIN_BACKGROUND)
bottomBar.setBackgroundColor(COLOR_CARD_BACKGROUND)

NoteTitle.setTextColor(COLOR_ON_BACKGROUND)
NoteText.setTextColor(COLOR_ON_BACKGROUND_SEC)
date.setText(文件修改时间(path))

NoteText.setLineSpacing(dp2px(2), 1)
mainTitle.getPaint().setFakeBoldText(true)
设置字体(mainTitle)
NoteTitle.getPaint().setFakeBoldText(true)
设置字体(NoteTitle)
设置字体(NoteText)
设置字体(wordNumber)
设置字体(date)

webView.setHorizontalScrollBarEnabled(false)
webView.setVerticalScrollBarEnabled(false)
webView.getSettings().setDisplayZoomControls(false) --隐藏缩放控件

水波纹(popmenu)
水波纹(back)
水波纹(delete)
水波纹(undo)
水波纹(redo)

function getRealPosition()
  if NoteText.getSelectionStart()~=-1 then
    return NoteText.getSelectionStart()
   else
    return NoteText.length()
  end
end

--[[function getLineText(cursor) --获取布局上的单行文字
  local layout = NoteText.getLayout()
  local lineStart = layout.getLineStart(layout.getLineForOffset(cursor))
  local lineEnd = layout.getLineEnd(layout.getLineForOffset(cursor))
  local lineText = String(NoteText.getText().toString()).substring(lineStart, lineEnd)
  return lineText
end]]

function getLineText(cursor)
  local text = NoteText.Text
  local lineStart = String(text).lastIndexOf("\n", cursor-1) + 1
  local lineEnd = String(text).indexOf("\n", cursor)
  if lineEnd == -1 then
    lineEnd = String(text).length()
  end
  return String(text).substring(lineStart, lineEnd);
end

function insertText(cursor, text)
  NoteText.getEditableText().insert(cursor, text)
end

function deleteText(from, to)
  NoteText.getEditableText().delete(from, to)
end

function setSelection(cursor)
  NoteText.setSelection(cursor)
end

if ishelp then
  delete.setVisibility(View.GONE)
end

if sharedData.enableMDTools then
  NoteText.getViewTreeObserver().addOnGlobalLayoutListener({
    onGlobalLayout = function()
      local function isKeyboardVisible(rootView)
        local r = Rect()
        rootView.getWindowVisibleDisplayFrame(r)
        local screenHeight = rootView.getRootView().getHeight()
        local keyboardHeight = screenHeight - r.bottom
        return keyboardHeight > 0
      end

      if isKeyboardVisible(NoteText) then
        NoteText.setPadding(dp2px(4), dp2px(4), dp2px(4), dp2px(56))
       else
        NoteText.setPadding(dp2px(4), dp2px(4), dp2px(4), dp2px(4))
      end
  end})
end

import "android.text.Spannable"
import "android.text.SpannableStringBuilder"
import "android.text.style.*"
import "android.text.Editable"
function parseMarkdown(editText)
  if sharedData.closeParseMD ~= true then
    local spannable = editText.getEditableText()
    local text = editText.text

    --重置spans，不能用clearSpans()否则EditText会出问题
    local spanClasses = {
      StyleSpan,
      StrikethroughSpan,
      UnderlineSpan,
      BackgroundColorSpan,
      BulletSpan,
      QuoteSpan,
      RelativeSizeSpan
    }
    for k, v in ipairs(spanClasses) do
      local spans = spannable.getSpans(0, spannable.length(), v)
      for _, span in ipairs(luajava.astable(spans)) do
        spannable.removeSpan(span)
      end
    end

    --防止带下划线的URL被处理
    -- * _
    for k,v in ipairs(regMatch("([\\*_]{1})([^[\\*_]\\n]+)([\\*_]{1})(?![\\*_])", text)) do
      if not getLineText(v.start):find("[<%(].-[%)>]") then
        spannable.setSpan(StyleSpan(Typeface.ITALIC), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      end
    end
    -- ** __
    for k,v in ipairs(regMatch("([\\*_]{2})([^[\\*_]\\n]+)([\\*_]{2})(?![\\*_])", text)) do
      if not getLineText(v.start):find("[<%(].-[%)>]") then
        spannable.setSpan(StyleSpan(Typeface.BOLD), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      end
    end
    -- *** ___
    for k,v in ipairs(regMatch("([\\*_]{3})([^[\\*_]\\n]+)([\\*_]{3})(?![\\*_])", text)) do
      if not getLineText(v.start):find("[<%(].-[%)>]") then
        spannable.setSpan(StyleSpan(Typeface.BOLD_ITALIC), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      end
    end
    -- ~~
    for k,v in ipairs(regMatch("(\\~{2})(.*)(\\~{2})", text)) do
      spannable.setSpan(StrikethroughSpan(), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    -- <u>
    for k,v in ipairs(regMatch("(<u>)([^<>\\n]+)(</u>)", text)) do
      spannable.setSpan(UnderlineSpan(), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    -- `
    for k,v in ipairs(regMatch("(`)([^`\\n]+)(`)", text)) do
      spannable.setSpan(BackgroundColorSpan(0x88e1e1e1), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    -- -+*
    for k,v in ipairs(regMatch("([-\\+\\*] )(.*)", text)) do
      spannable.setSpan(BulletSpan(8), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    -- >
    for k,v in ipairs(regMatch("(> )(.*)", text)) do
      spannable.setSpan(QuoteSpan(0xffe0e0e0, 8, 0), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    -- #
    for k,v in ipairs(regMatch("(#{1,6})( )(.*)", text)) do
      spannable.setSpan(StyleSpan(Typeface.BOLD), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      local level = v.group1.length()
      switch level
       case 1
        spannable.setSpan(RelativeSizeSpan(1.5), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
       case 2
        spannable.setSpan(RelativeSizeSpan(1.3), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
       case 3
        spannable.setSpan(RelativeSizeSpan(1.15), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
       case 4
        spannable.setSpan(RelativeSizeSpan(1.0), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
       case 5
        spannable.setSpan(RelativeSizeSpan(0.9), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
       case 6
        spannable.setSpan(RelativeSizeSpan(0.85), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      end
    end
    --链接
    for k, v in pairs(regMatch("\\[(.*)\\]\\((.*)\\)", text)) do
      if v.start-1 > 0 then
        if String(text).substring(v.start-1, v.start) ~= "!" then
          spannable.setSpan(URLSpan(v.group2), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
        end
       else
        spannable.setSpan(URLSpan(v.group2), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      end
    end
    for k, v in pairs(regMatch("(<)(https?:\\/\\/\\S+)(>)", text)) do
      spannable.setSpan(URLSpan(v.group2), v.start, v.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    end
    --图片
    local function setImageSpan(path, tab, spannable)
      local drawable = BitmapDrawable(loadbitmap(path))
      if drawable.getIntrinsicWidth() ~= -1 then
        if drawable.getIntrinsicWidth() * dp^2 < activity.width - dp2px(32) then
          local w = drawable.getIntrinsicWidth() * dp^2
          local h = drawable.getIntrinsicHeight() * dp^2
          drawable.setBounds(0, 0, w, h)
         else
          local r = drawable.getIntrinsicWidth() / drawable.getIntrinsicHeight()
          if activity.width < activity.height then
            local w = activity.width - dp2px(32)
            local h = w / r
            drawable.setBounds(0, 0, w, h)
           else
            local w = activity.width / 2 - dp2px(32)
            local h = w / r
            drawable.setBounds(0, 0, w, h)
          end
        end
        spannable.setSpan(ImageSpan(drawable, ImageSpan.ALIGN_BASELINE), tab.start, tab.ends, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
      end
    end
    for k, v in pairs(regMatch("!\\[(.*)\\]\\((.*)\\)", text)) do
      local path = tostring(v.group2)
      if path:sub(1, 1) ~= "/" then
        Http.get(path,nil,"utf8",nil,function(code,content,cookie,header)
          if code == 200 then
            setImageSpan(path, v, spannable)
          end
        end)
       else
        setImageSpan(path, v, spannable)
      end
    end
  end
end

if createTime == nil then --非新建便签
  NoteTitle.setText(File(path).getName())
  NoteText.setText(读取文件(path))
  parseMarkdown(NoteText)
  activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN)
end

if NoteText.text:sub(-9,-1)=="\n[浏览]" then
  read=true
end

if read == true then
  NoteBackground.setVisibility(View.GONE)
  undo.setVisibility(View.GONE)
  redo.setVisibility(View.GONE)
  bottomBar.setVisibility(View.GONE)
  mainTitle.setText("浏览")
  loadingMD()
 else
  if sharedData.closemarkdown==true then
    webView.setVisibility(View.GONE)
  end
  mainTitle.setText("编辑")
end

if sharedData.openType == "默认置底" then
  NoteText.requestFocus()
  NoteText.setSelection(NoteText.length())
  task(100,function()
    NoteBackground.fullScroll(View.FOCUS_DOWN)
  end)
 else
  task(1,function()
    NoteText.requestFocus()
    NoteText.setSelection(0)
    NoteBackground.scrollTo(0,0)
  end)
end

if sharedData.enableMDTools ~= true then
  bottomBar.setVisibility(View.GONE)
end

ratio=activity.Height/activity.Width

function mdViewDetector()
  if 0.7<ratio and ratio<1.4 then
    NoteBackground.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,LinearLayout.LayoutParams.FILL_PARENT,0))
   else
    if activity.width<activity.height then
      NoteBackground.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,LinearLayout.LayoutParams.FILL_PARENT,0))
     elseif activity.width>activity.height then
      NoteBackground.setLayoutParams(LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,LinearLayout.LayoutParams.FILL_PARENT,1))
      loadingMD()
    end
  end
end
mdViewDetector()
currentOrientation=activity.resources.configuration.orientation
oldOrientation=currentOrientation
luajava.override(OrientationListener, {
  onOrientationChanged=function(_, orientation)
    currentOrientation=activity.resources.configuration.orientation
    if currentOrientation~=oldOrientation then
      mdViewDetector()
      oldOrientation=currentOrientation
    end
end}).enable()

data={
  {icon=ICON_MD_BOLD},
  {icon=ICON_MD_ITALIC},
  {icon=ICON_MD_UNDERLINED},
  {icon=ICON_MD_STRIKETHROUGH},
  {icon=ICON_MD_HRADLINE},
  {icon=ICON_MD_LIST_BULLETED},
  {icon=ICON_MD_LIST_NUMBERED},
  {icon=ICON_MD_IMAGE},
  {icon=ICON_MD_CHECK_BOX},
  {icon=ICON_MD_CHECKED_BOX},
  {icon=ICON_MD_CODE},
  {icon=ICON_MD_QUOTE},
  {icon=ICON_MD_TASK},
}

MD_BOLD=1
MD_ITALIC=2
MD_UNDERLINED=3
MD_STRIKETHROUGH=4
MD_HEADLINE=5
MD_LISTBULLTED=6
MD_LISTNUMBERED=7
MD_IMAGE=8
MD_CHECKBOX=9
MD_CHECKEDBOX=10
MD_CODE=11
MD_QUOTE=12
MD_TASK=13

adapter = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount = function()
    return #data
  end,
  getItemViewType = function(position)
    return 0
  end,
  onCreateViewHolder = function(parent,viewType)
    local views = {}
    local holder = LuaCustRecyclerHolder(loadlayout({
      LinearLayout;
      id="bottomBarItem";
      layout_height="wrap";
      layout_width="wrap";
      padding="10dp";
      {
        ImageView;
        id="bottomBarImage";
        layout_height="20dp";
        layout_width="20dp";
      };
    }, views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder = function(holder, position)
    local view = holder.view.getTag()
    local index = position+1
    view.bottomBarImage.setImageDrawable(BitmapDrawable(loadbitmap(data[index].icon)))
    水波纹(view.bottomBarItem)
    view.bottomBarItem.onClick=function(view)
      switch index
       case MD_BOLD
        insertText(getRealPosition(),"****")
        setSelection(getRealPosition()-2)
       case MD_ITALIC
        insertText(getRealPosition(),"**")
        setSelection(getRealPosition()-1)
       case MD_UNDERLINED
        insertText(getRealPosition(),"<u></u>")
        setSelection(getRealPosition()-4)
       case MD_STRIKETHROUGH
        insertText(getRealPosition(),"~~~~")
        setSelection(getRealPosition()-2)
       case MD_LISTBULLTED
        insertText(getRealPosition(),"- ")
       case MD_LISTNUMBERED
        local cursor = getRealPosition()
        local lineText = getLineText(cursor)
        if lineText ~= "" then
          if cursor-2 >= 0 then
            if String(NoteText.Text).substring(cursor-2, cursor) ~= "  " then
              insertText(cursor,"  \n")
             else
              insertText(cursor,"\n")
            end
           else
            insertText(cursor,"  \n")
          end

          local headerNum = lineText:match("^%d*")
          if headerNum ~= "" then
            if lineText:match("^"..headerNum.."%. ") then
              insertText(getRealPosition(),
              tostring(tonumber(headerNum)+1)..". ")
             else
              insertText(getRealPosition(),"1. ")
            end
           else
            insertText(getRealPosition(),"1. ")
          end
         else
          if cursor-1 >= 0 then
            local cursor = getRealPosition()-1
            local lineText = getLineText(cursor)
            if lineText ~= "" then
              local headerNum = lineText:match("^%d*")
              if headerNum ~= "" then
                insertText(getRealPosition(),
                tostring(tonumber(headerNum)+1)..". ")
               else
                insertText(getRealPosition(),"1. ")
              end
             else
              insertText(getRealPosition(),"1. ")
            end
           else
            insertText(getRealPosition(),"1. ")
          end
        end
       case MD_CHECKBOX
        insertText(getRealPosition(),"- [ ] ")
       case MD_CHECKEDBOX
        insertText(getRealPosition(),"- [x] ")
       case MD_CODE
        insertText(getRealPosition(),"``")
        setSelection(getRealPosition()-1)
       case MD_QUOTE
        insertText(getRealPosition(),"> ")
       case MD_IMAGE
        nobak=true
        if sharedData.addImageType=="系统相册" then
          openAlbumIntent = Intent(Intent.ACTION_PICK)
          openAlbumIntent.setType("image/*")
          activity.startActivityForResult(openAlbumIntent, 1)
         else
          ext={".png",".jpg",".jpeg",".gif"}
          activity.setSharedData("selected",nil)
          activity.newActivity("chooseFile",{ext})
        end
       case MD_TASK
        insertText(NoteText.length(),"\n[浏览]")
       case MD_HEADLINE
        local cursor = getRealPosition()
        local lineText = getLineText(cursor)
        if lineText ~= "" then
          if cursor-2 >= 0 then
            if String(NoteText.Text).substring(cursor-2, cursor) == "# " then
              insertText(cursor-1,"#")
             else
              if String(NoteText.Text).substring(cursor-1, cursor) == "#" then
                insertText(cursor,"# ")
               else
                if String(NoteText.Text).substring(cursor-2, cursor) == "  " then
                  insertText(cursor,"\n# ")
                 else
                  insertText(cursor,"  \n# ")
                end
              end
            end
           else
            insertText(cursor,"# ")
          end
         else
          insertText(cursor,"# ")
        end
      end
    end
  end
}))

bottomBarRecycler.setAdapter(adapter)
bottomBarRecycler.setLayoutManager(LinearLayoutManager(activity,RecyclerView.HORIZONTAL,false))

NoteText.setOnKeyListener{
  onKey=function(v, keyCode, event)
    if event.getAction() == KeyEvent.ACTION_DOWN then
      if keyCode == KeyEvent.KEYCODE_ENTER then
        local done
        local cursor = getRealPosition()

        local afterStr1 = ""
        local afterStr2 = ""
        if cursor+2 <= NoteText.length() then
          afterStr2 = String(NoteText.Text).substring(cursor, cursor+2)
         elseif cursor+1 <= NoteText.length() then
          afterStr1 = String(NoteText.Text).substring(cursor, cursor+1)
        end
        if afterStr2 == "**" or afterStr2 == "++" or afterStr2 == "~~" then
          cursor = cursor+2
          setSelection(cursor)
          done = true
         else
          if afterStr1 == "*" or afterStr1 == "`" then
            cursor = cursor+1
            setSelection(cursor)
            done = true
          end
        end
        local foreStr3 = ""
        local afterStr4 = ""
        if cursor-3 >= 0 then
          foreStr3 = String(NoteText.Text).substring(cursor-3, cursor)
        end
        if cursor+4 <= NoteText.length() then
          afterStr4 = String(NoteText.Text).substring(cursor, cursor+4)
        end
        if foreStr3 == "<u>" and afterStr4 == "</u>" then
          cursor = cursor+4
          setSelection(cursor)
          done = true
        end

        if done ~= true then
          if cursor-2 >= 0 then
            if String(NoteText.Text).substring(cursor-2, cursor) ~= "  " then
              insertText(cursor,"  \n")
             else
              insertText(cursor,"\n")
            end
           else
            insertText(cursor,"  \n")
          end

          local lineText = getLineText(cursor)
          local headerNum = lineText:match("^%d*")
          if headerNum ~= "" then
            if lineText:match("^"..headerNum.."%. ") then
              insertText(getRealPosition(),tostring(tonumber(headerNum)+1)..". ")
            end
          end
        end

        return true
      end
      if keyCode == KeyEvent.KEYCODE_DEL then
        local cursor = getRealPosition()

        local foreStr1 = ""
        local afterStr1 = ""
        local afterStr2 = ""
        if cursor-1 >= 0 then
          foreStr1 = String(NoteText.Text).substring(cursor-1, cursor)
        end
        if cursor+1 <= NoteText.length() then
          afterStr1 = String(NoteText.Text).substring(cursor, cursor+1)
        end
        if cursor+2 <= NoteText.length() then
          afterStr2 = String(NoteText.Text).substring(cursor, cursor+2)
        end
        if foreStr1 == "*" and afterStr1 == "*"
          or foreStr1 == "+" and afterStr1 == "+"
          or foreStr1 == "~" and afterStr1 == "~"
          or foreStr1 == "`" and afterStr1 == "`"
          or foreStr1 == ">" and afterStr1 == "<"
          or foreStr1 == "<" and afterStr1 == ">"
          then
          deleteText(cursor, cursor+1)
        end

        if foreStr1 == "u" and afterStr2 == "/u"
          deleteText(cursor, cursor+2)
        end

        if foreStr1 == "\n" and afterStr2 == "  " then
          deleteText(cursor, cursor+2)
          task(1,function()
            setSelection(getRealPosition()-2)
          end)
        end

        return false
      end
    end
end}

NoteText.onClick=function()
  if NoteText.hasSelection() ~= true then
    local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
    local function hideImm()
      imm.hideSoftInputFromWindow(NoteText.getWindowToken(), 0)
    end

    local s = NoteText.getText()
    local imageSpans = s.getSpans(0, s.length(), ImageSpan)
    local selectionStart = getRealPosition()

    for _, span in ipairs(luajava.astable(imageSpans)) do
      start = s.getSpanStart(span)
      ends = s.getSpanEnd(span)
      if selectionStart >= start and selectionStart < ends then
        hideImm()

        --[[local bitmap = span.getDrawable().getBitmap()
        local uri = Uri.parse(MediaStore.Images.Media.insertImage(activity.getContentResolver(), bitmap, nil, nil))]]
        local text = s.substring(start, ends)
        local path = tostring(text):match("!%[.-%]%((.-)%)")
        local file = File(path)

        local success, err = pcall(function()
          local uri
          if path:sub(1,1) == "/" then
            if Build.VERSION.SDK_INT >= Build.VERSION_CODES.N then
              uri = FileProvider.getUriForFile(activity, "com.onedongua.note", file);
             else
              uri = Uri.fromFile(file)
            end
           else
            uri = Uri.parse(path)
          end

          local intent = Intent(Intent.ACTION_VIEW)
          intent.setDataAndType(uri, "image/*")
          intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

          local packageName = sharedData.viewImagePackageName
          if packageName ~= nil then
            intent.setPackage(packageName)
          end

          activity.startActivity(intent)
        end)

        if success then
          return true
         else
          --print(err)
        end
      end
    end

    local urlSpans = s.getSpans(0, s.length(), URLSpan)
    for _, span in ipairs(luajava.astable(urlSpans)) do
      start = s.getSpanStart(span)
      ends = s.getSpanEnd(span)
      if selectionStart > start and selectionStart < ends then
        hideImm()

        local text = s.substring(start, ends)
        local url
        if text:sub(1, 1) == "<" then
          url = text:match("<(.-)>")
         else
          url = text:match("%[.-%]%((.-)%)")
        end
        local intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        activity.startActivity(intent)
        return true
      end
    end

    local cursor = getRealPosition()
    local afterStr1 = ""
    local afterStr2 = ""
    local foreStr2 = ""
    local foreStr3 = ""
    local foreStr4 = ""
    if cursor+1 <= NoteText.length() then
      afterStr1 = String(NoteText.Text).substring(cursor, cursor+1)
    end
    if cursor+2 <= NoteText.length() then
      afterStr2 = String(NoteText.Text).substring(cursor, cursor+2)
    end
    if cursor-2 >= 0 then
      foreStr2 = String(NoteText.Text).substring(cursor-2, cursor)
    end
    if cursor-3 >= 0 then
      foreStr3 = String(NoteText.Text).substring(cursor-3, cursor)
    end
    if cursor-4 >= 0 then
      foreStr4 = String(NoteText.Text).substring(cursor-4, cursor)
    end

    if foreStr2 == "  " and (afterStr1 == "\n" or afterStr1 == "") then
      setSelection(getRealPosition()-2)
    end
    if foreStr3:match("%- %[") and afterStr2:match(" %]") then
      deleteText(cursor, cursor+1)
      insertText(cursor, "x")
      setSelection(getRealPosition()+2)
    end
    if foreStr4:match("%- %[ ") and afterStr1:match("%]") then
      insertText(cursor, "x")
      deleteText(cursor-1, cursor)
      setSelection(getRealPosition()+2)
    end
    if foreStr3:match("%- %[") and afterStr2:match("x%]") then
      deleteText(cursor, cursor+1)
      insertText(cursor, " ")
      setSelection(getRealPosition()+2)
    end
    if foreStr4:match("%- %[x") and afterStr1:match("%]") then
      insertText(cursor, " ")
      deleteText(cursor-1, cursor)
      setSelection(getRealPosition()+2)
    end

  end
end

function onKeyDown(keycode, event)
  if keycode == 4 then
    if read then
      NoteBackground.setVisibility(View.VISIBLE)
      undo.setVisibility(View.VISIBLE)
      redo.setVisibility(View.VISIBLE)
      if sharedData.enableMDTools == true then
        bottomBar.setVisibility(View.VISIBLE)
      end
      mainTitle.setText("编辑")
      read = false
      return true
     else
      nobak = true
      save()
      return true
    end
  end
end

mainTitle.onClick = function(view)
  NoteBackground.fullScroll(View.FOCUS_UP)
end

popmenu.onClick = function(view)
  pop = PopupMenu(activity,popmenu)
  menu = pop.Menu

  if not read then
    menu.add("不保存并退出")
    .onMenuItemClick = function(a)
      dialog = AlertDialog.Builder(this)
      dialog.setTitle("是否直接退出？")
      dialog.setMessage("操作将无法撤销")
      dialog.setPositiveButton("确定",{onClick = function(v)
          activity.finish()
      end})
      dialog.setNegativeButton("取消",nil)
      dialog.show()
    end

    menu.add("查看备份")
    .onMenuItemClick = function(a)
      nobak = true
      forcesave = true
      local success = save()
      if success then
        thisNote = {}
        thisNote.path = parentPath..NoteTitle.Text
        activity.newActivity("backup", {thisNote})
      end
    end
  end

  menu.add("推送至通知栏")
  .onMenuItemClick = function(a)
    local notificationManager = this.getSystemService(Context.NOTIFICATION_SERVICE)
    local notification = NotificationCompat.Builder(this, "0")--渠道ID
    .setContentTitle(NoteTitle.Text)--标题
    .setContentText(NoteText.Text)--文本
    .setSmallIcon(R.drawable.ic_launcher)--小图标
    .setAutoCancel(false)--是否自动消失
    .setWhen(System.currentTimeMillis())--通知时间
    .setPriority(NotificationCompat.PRIORITY_DEFAULT)--重要程度
    notificationManager.notify(1, notification.build());
    print("成功")
  end

  menu.add("保存图片")
  .onMenuItemClick = function(a)
    local function showDialog(bitmap)
      local dialog = AlertDialog.Builder(this)
      .setTitle("预览")
      .setView(loadlayout({
        ScrollView;
        layout_width="fill";
        layout_height="fill";
        verticalScrollBarEnabled=false;
        {
          ImageView;
          id="saveImageView";
          layout_width="wrap";
          layout_height="wrap";
          adjustViewBounds="true";
        }
      }))
      .setPositiveButton("保存", {onClick = function(view)
          local path = savedPicPath..NoteTitle.text..os.date("_%Y%m%d_%H%M%S")..".jpg"
          bitmapToFile(bitmap, path)
          if File(path).isFile() then
            print("保存成功")
            MediaScannerConnection.scanFile(activity, {path}, nil, nil) --通知媒体库更新
           else
            print("保存失败")
          end
      end})
      .setNegativeButton("取消", nil)
      .setOnDismissListener({
        onDismiss = function(dialogInterface)
          webView.scrollTo(0, 1)
      end})
      .show()
    end
    if read then
      webviewToBitmap(webView, function(bitmap)
        showDialog(bitmap)
        saveImageView.setImageBitmap(bitmap)
      end)
     else
      NoteBackground1.setVisibility(View.GONE)
      NoteBackground1.setVisibility(View.VISIBLE)
      local bitmap = viewToBitmap(NoteBackground1)
      showDialog(bitmap)
      saveImageView.setImageBitmap(bitmap)
    end
  end

  if not read then
    menu.add("浏览")
    .onMenuItemClick = function(a)
      NoteBackground.setVisibility(View.GONE)
      undo.setVisibility(View.GONE)
      redo.setVisibility(View.GONE)
      if sharedData.enableMDTools == true then
        bottomBar.setVisibility(View.GONE)
      end
      mainTitle.setText("浏览")
      read = true
      loadingMD()
    end
   else
    menu.add("返回编辑")
    .onMenuItemClick = function(a)
      NoteBackground.setVisibility(View.VISIBLE)
      undo.setVisibility(View.VISIBLE)
      redo.setVisibility(View.VISIBLE)
      if sharedData.enableMDTools == true then
        bottomBar.setVisibility(View.VISIBLE)
      end
      mainTitle.setText("编辑")
      read = false
    end
  end

  pop.show()
end

back.onClick=function(view)
  if read then
    NoteBackground.setVisibility(View.VISIBLE)
    undo.setVisibility(View.VISIBLE)
    redo.setVisibility(View.VISIBLE)
    if sharedData.enableMDTools == true then
      bottomBar.setVisibility(View.VISIBLE)
    end
    mainTitle.setText("编辑")
    read = false
   else
    nobak = true
    save()
  end
end

delete.onClick=function(view)
  nobak = true
  if createTime and NoteTitle.Text == "" and NoteText.Text == "" then
    os.remove(path)
    activity.finish()
   else
    updateWebdavInfo()
    if NoteTitle.Text == "" then
      NoteTitle.setText(os.date("%Y-%m-%d %H-%M-%S"))
    end
    delPath=parentPath:gsub(pathn, pathr)..NoteTitle.Text
    if File(delPath).isFile() then
      dialog = AlertDialog.Builder(this)
      dialog.setTitle("是否覆盖")
      dialog.setMessage("回收站已存在相同标题文件")
      dialog.setPositiveButton("确定",{onClick=function(v)
          os.remove(path)
          写入文件(delPath,NoteText.Text)
          if File(delPath).isFile() then
            if File(path).isFile() then
              print("删除失败")
             else
              print("删除成功")
              activity.finish()
            end
          end
      end})
      dialog.setNegativeButton("取消",nil)
      dialog.show()
     else
      创建父文件(delPath)
      os.remove(path)
      写入文件(delPath,NoteText.Text)
      if File(delPath).isFile() then
        if File(path).isFile() then
          print("删除失败")
         else
          print("删除成功")
          activity.finish()
        end
      end
    end
  end
end

count = 1
statu = false
his = {}
pos = {}
table.insert(his, count, NoteText.Text)
table.insert(pos, count, NoteText.getSelectionStart())
undo.onClick = function(view)
  if his[count-1] then
    statu = true
    count = count-1
    NoteText.setText(his[count])
    setSelection(pos[count])
  end
end
redo.onClick=function(view)
  if his[count+1] then
    statu = true
    count = count+1
    NoteText.setText(his[count])
    setSelection(pos[count])
  end
end

NoteText.addTextChangedListener{
  onTextChanged = function(s)
    if statu == true then
      statu = false
     else
      for i = #his, count+1, -1 do
        table.remove(his, i)
        table.remove(pos, i)
      end
      count = count+1
      table.insert(his, count, NoteText.Text)
      table.insert(pos, count, NoteText.getSelectionStart())
    end
    if count == 500 then
      table.remove(his, 1)
      table.remove(pos, 1)
      count = count-1
    end
end}

function saveBackup()
  local ls = luajava.astable(File(pathb).listFiles())
  local thisBak = {}
  local title
  if NoteTitle.text == "" then
    title = createTime
   else
    title = NoteTitle.text
  end
  for k, v in ipairs(ls) do
    if v.getName():find("["..title.."]") then
      local time = tonumber(tostring(v):match("%d+$"))
      table.insert(thisBak, {file=v, time=time})
    end
  end
  if #thisBak > 4 then
    local delBak = thisBak
    table.sort(delBak, function(a, b) return a.time > b.time end)
    for i = 1, 4 do
      table.remove(delBak, 1)
    end
    for k, v in ipairs(delBak) do
      v.file.delete()
    end
  end
  写入文件(pathb..title..os.date("-%Y%m%d%H%M%S"), NoteText.text)
end

time = os.time()
function setWordNumber()
  local realWord=NoteText.Text:gsub("%[.-%]%(.-%)",""):gsub("\n",""):gsub(" ","")
  wordNumber.setText(tostring(String(realWord).length()).."个字")
end
setWordNumber()
lastLength = 0
NoteText.addTextChangedListener{
  afterTextChanged=function(s)
    if s.length() < 5000 then
      parseMarkdown(NoteText)
     elseif s.length() == 5000 and s.length() > lastLength then
      print("为保障流畅编辑，已自动暂停MD渲染")
    end
    lastLength = s.length()
    setWordNumber()
    if sharedData.closemarkdown ~= true then
      if activity.Width > activity.Height or 0.7 < ratio and ratio < 1.4 then
        markdown()
        webView.reload()
      end
    end
    if sharedData.autoBak then
      autoBakTime = tonumber(sharedData.autoBakTime)
      if time + autoBakTime < os.time() then
        saveBackup()
        time = os.time()
      end
    end
end}

NoteTitle.addTextChangedListener{
  onTextChanged=function(s)
    if sharedData.closemarkdown ~= true then
      if activity.Width > activity.Height or 0.7 < ratio and ratio < 1.4 then
        markdown()
        webView.reload()
      end
    end
end}

function onPause()
  if nobak ~= true then
    saveBackup()
  end
end

function addImageSpan(picPath)
  local newPicPath = notePicPath..File(picPath).getName()
  os.execute("cp -f \""..picPath.."\" \""..newPicPath.."\"")
  local imageText = ("![]("..newPicPath..")")
  insertText(getRealPosition(), "\n")
  insertText(getRealPosition(), imageText)
  insertText(getRealPosition(), "\n")
end

function onActivityResult(requestCode, resultCode, data)
  if requestCode == 1 and data then
    local cursor = activity.getContentResolver().query(data.getData(), nil, nil, nil, nil)
    cursor.moveToFirst()
    local picPath = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA))
    addImageSpan(picPath)
  end
end

function onResume()
  nobak = false
  time = os.time()

  local selected = activity.getSharedData("selected")
  if selected ~= nil then
    activity.setSharedData("selected", nil)
    addImageSpan(selected)
  end
end
