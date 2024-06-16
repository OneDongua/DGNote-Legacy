--导入
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

import "android.view.animation.DecelerateInterpolator"

import "androidx.core.app.NotificationCompat"
import "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"
import "androidx.recyclerview.widget.RecyclerView"
import "androidx.recyclerview.widget.LinearLayoutManager"
import "androidx.recyclerview.widget.StaggeredGridLayoutManager"

import "java.io.File"
import "java.io.FileOutputStream"
import "java.lang.String"
import "java.util.regex.Pattern"

import "com.androlua.LuaUtil"

import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"

import "android.graphics.Color"
import "android.graphics.Typeface"
import "android.graphics.drawable.*"
import "android.graphics.Bitmap"
import "android.graphics.Canvas"
import "android.graphics.Paint"
import "android.graphics.Rect"

import "android.content.res.ColorStateList"
import "android.content.Context"
import "android.content.Intent"
import "android.content.FileProvider"
import "android.provider.MediaStore"
import "android.media.MediaScannerConnection"

import "android.text.InputType"

import "android.net.Uri"
import "android.webkit.WebView"
import "android.webkit.CookieManager"

import "com.onedongua.note2.R"

import "com.lua.custrecycleradapter.*"

import "libs/sardine"

import "cjson"

if activity then
  this=activity
 elseif service then
  this=service
end

--一次性获取SharedData方便调用
function refreshSharedData()
  sharedData = this.getSharedData()
end
refreshSharedData()

--内部存储路径变量
dir=this.getApplicationContext().getFilesDir().getAbsolutePath().."/"
pathc=dir.."files/"
pathn=pathc.."note/"
pathr=pathc.."recycle/"
patht=pathc.."cache/"
pathb=pathc.."backup/"
pathh=pathc.."help/"
pathf=pathc.."fonts/"

--外部存储路径变量
sdPath=Environment.getExternalStorageDirectory().getAbsolutePath().."/"
picPath=Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath().."/"
notePicPath=picPath.."DGNote/"
savedPicPath=picPath.."DGNoteSaved/"

--状态栏高度
StatusBarHeight=this.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)

--dpi
dpi = this.getResources().getDisplayMetrics().densityDpi
dp = this.getResources().getDisplayMetrics().density

--设备信息
deviceInfo={}
deviceInfo.brand = Build.BRAND
deviceInfo.device = Build.DEVICE
deviceInfo.model = Build.MODEL
deviceInfo.os_version = Build.VERSION.RELEASE

--function

function 父目录(path)
  return tostring(File(tostring(path)).getParentFile()).."/"
end

function 创建父文件(path)
  File(tostring(path)).getParentFile().mkdirs()
end

function 创建文件(path)
  File(tostring(path)).createNewFile()
end

function 创建文件夹(path)
  File(tostring(path)).mkdirs()
end

function 读取文件(path)
  return io.open(tostring(path)):read("*a")
end

function 写入文件(path,text)
  io.open(tostring(path),"w"):write(tostring(text)):close()
end

function convertToLocaleTime(time)
  local cal = Calendar.getInstance()
  cal.setTimeInMillis(time)
  return cal.getTime().toLocaleString()
end

function 文件修改时间(path, returnIntOnly)
  path = tostring(path)
  local time
  if path:find(pathn) and File(pathc.."MetaData.json").isFile() then
    local tree = cjson.decode(读取文件(pathc.."MetaData.json"))
    local item = readTree(tree, path, pathn)
    if item then
      time = item.time
    end
  end
  if not time then
    time = File(path).lastModified()
  end
  if returnIntOnly then
    return time
   else
    return convertToLocaleTime(time)
  end
end

function getNetworkInfo()
  return activity.getSystemService(Context.CONNECTIVITY_SERVICE).getActiveNetworkInfo()
end

function html美化(t)
  local style1
  local style2
  local font=sharedData.font
  if font ~= "无" and font ~= nil then
    local fontname=font:match("(.+)%.%w")
    style1=[[<style>
@font-face {
    font-family: ]]..fontname..[[;
    src: url(]]..pathf..font..[[);
}
* {
    color: #]]..string.format("%#x",COLOR_ON_BACKGROUND):match("0xff(.+)")..[[;
    font-family: ]]..fontname..[[
}
]]
   else
    style1=[[<style>
* {
    color: #]]..string.format("%#x",COLOR_ON_BACKGROUND):match("0xff(.+)")..[[;
}
]]
  end
  style2=[[table,table tr th,table tr td {
	border: 1px solid #cccccc;
}
table {
	border-collapse: collapse;
}
blockquote {
    position: relative;
    padding: 8px 15px 8px 15px;
    box-sizing: border-box;
    background: rgba(225,225,225,0.3);
    color: #DDDDDD;
    border-left: 4px solid #e0e0e0;
}
pre,p code {
    position: relative;
    box-sizing: border-box;
    border-radius: 4px;
    background: rgba(225,225,225,0.5);
    white-space: pre-wrap;
    white-space: -moz-pre-wrap;
    white-space: -pre-wrap;
    white-space: -o-pre-wrap;
    word-wrap: break-word;
}
img, video {
  max-width: 320
}
</style>
]]..t.."<br><br>"
  return style1..style2
end

function delOldBak()
  local ls=luajava.astable(File(pathb).listFiles())
  for k,v in ipairs(ls) do
    local lastModTime=math.floor(v.lastModified()/1000)
    local autoDelOldBakTime=15*86400
    if lastModTime+autoDelOldBakTime<os.time() then
      os.remove(tostring(v))
    end
  end
end

function delOldRecycle()
  local ls=luajava.astable(File(pathr).listFiles())
  for k,v in ipairs(ls) do
    local lastModTime=math.floor(v.lastModified()/1000)
    if lastModTime+30*86400<os.time() then
      os.remove(tostring(v))
    end
  end
end

function sort(ls, k)
  local function startToNumber(s)
    return tonumber(s:match("^%d*")) or math.huge
  end
  local function endToNumber(s)
    return tonumber(s:match("%d*$")) or math.huge
  end

  if sharedData.sort == "名称正序" or k == 1 then
    table.sort(ls, function(a, b)
      local startA = startToNumber(a.Name)
      local startB = startToNumber(b.Name)
      if startA == startB then
        if a.Name:gmatch("%D*") == b.Name:gmatch("%D*") then
          local endA = endToNumber(a.Name)
          local endB = endToNumber(b.Name)
          return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
          or (a.isDirectory()==b.isDirectory() and endA < endB)
         else
          return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
          or (a.isDirectory()==b.isDirectory() and string.upper(a.Name) < string.upper(b.Name))
        end
       else
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
        or (a.isDirectory()==b.isDirectory() and startA < startB)
      end
    end)

   elseif sharedData.sort == "名称倒序" or k == 2 then
    table.sort(ls, function(a, b)
      local startA = startToNumber(a.Name)
      local startB = startToNumber(b.Name)
      if startA == startB then
        if a.Name:gmatch("%D*") == b.Name:gmatch("%D*") then
          local endA = endToNumber(a.Name)
          local endB = endToNumber(b.Name)
          return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
          or (a.isDirectory()==b.isDirectory() and endA > endB)
         else
          return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
          or (a.isDirectory()==b.isDirectory() and string.upper(a.Name) > string.upper(b.Name))
        end
       else
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
        or (a.isDirectory()==b.isDirectory() and startA > startB)
      end
    end)

   elseif sharedData.sort == "修改时间正序" or k == 3 then
    table.sort(ls,function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
      or (b.isDirectory()==a.isDirectory() and 文件修改时间(a, true)<文件修改时间(b, true))
    end)

   elseif sharedData.sort == "修改时间倒序" or k == 4 then
    table.sort(ls,function(a,b)
      return (a.isDirectory()~=b.isDirectory() and a.isDirectory())
      or (b.isDirectory()==a.isDirectory() and 文件修改时间(b, true)<文件修改时间(a, true))
    end)

   else
    activity.setSharedData("sort","名称正序")
    sort(ls)
  end
end

function compareTables(a, b)
  local aOnly = {}
  local bOnly = {}
  local both = {}

  for _, item in ipairs(a) do
    local hasItem = false
    for _, bItem in ipairs(b) do
      if item == bItem then
        hasItem = true
        table.insert(both, item)
        break
      end
    end

    if not hasItem then
      table.insert(aOnly, item)
    end
  end

  for _, item in ipairs(b) do
    local hasItem = false
    for _, aItem in ipairs(a) do
      if item == aItem then
        hasItem = true
        break
      end
    end

    if not hasItem then
      table.insert(bOnly, item)
    end
  end

  return aOnly, bOnly, both
end

function createTree(file)
  local tab = {}
  local function tree(file, tab)
    local ls = luajava.astable(file.listFiles())
    for k, f in ipairs(ls) do
      local name = f.getName()
      if f.isDirectory() then
        tab[name] = {}
        tab[name]["type"] = "dir"
        tab[name]["path"] = f.getPath():gsub(pathn, "")
        tab[name]["child"] = {}
        tree(f, tab[name]["child"])
       elseif f.isFile() then
        tab[name] = {}
        tab[name]["type"] = "file"
        tab[name]["path"] = f.getPath():gsub(pathn, "")
        tab[name]["parentPath"] = (f.getParentFile().getPath().."/"):gsub(pathn, "")
        tab[name]["time"] = f.lastModified()
      end
    end
  end
  tree(file, tab)
  return tab
end

function updateTree(oldTree, base, newPath)
  local function tree(oldTree, path)
    local newTree = createTree(File(path))
    local resultTree = newTree
    for oldName, oldItem in pairs(oldTree) do
      for newName, newItem in pairs(newTree) do
        if oldName == newName then
          if oldItem.type == newItem.type then
            --type相同
            if oldItem.type == "file" then
              --均为file
              if oldItem.time ~= newItem.time then
                if newPath then
                  local p = newPath:gsub(base, "")
                  if p == oldItem.path then
                   else
                    resultTree[newName].time = oldItem.time
                  end
                 else
                  resultTree[newName].time = oldItem.time
                end
              end
             else
              --均为dir
              local dirTree = tree(oldItem.child, base..oldItem.path)
              resultTree[newName].child = dirTree
            end
          end
        end
      end
    end
    return resultTree
  end
  local resultTree = tree(oldTree, base)
  --写入文件(patht.."test.txt",dump(resultTree))
  return resultTree
end

function readTree(tree, path, base)
  path = path:gsub(base, "")
  local gmatched = path:gmatch("[^/]+")
  local names = {}
  for name in gmatched do
    table.insert(names, name)
  end
  local function read(tree, name, index)
    for treeName, treeItem in pairs(tree) do
      if treeName == name then
        if index < #names then
          index = index+1
          local resultItem = read(treeItem.child, names[index], index)
          return resultItem
         else
          return treeItem
        end
      end
    end
  end
  local result = read(tree, names[1], 1)
  return result
end

function compareTrees(old, new)
  local oldOnly = {}
  local newOnly = {}
  local oldNewer = {}
  local newNewer = {}

  local function compare(old, new)
    for oldName, oldItem in pairs(old) do
      local hasItem = false
      for newName, newItem in pairs(new) do
        if oldName == newName then
          hasItem = true
          if oldItem.type == newItem.type then
            --type相同
            if oldItem.type == "file" then
              --均为file
              if oldItem.time < newItem.time then
                table.insert(newNewer, newItem)
               elseif oldItem.time > newItem.time then
                table.insert(oldNewer, oldItem)
              end
             else
              --均为dir
              compare(oldItem.child, newItem.child)
            end
           else
            --type不相同
            table.insert(oldOnly, oldItem)
            table.insert(newOnly, newItem)
            if newItem.type == "dir" then
              compare(oldItem.child, newItem.child)
            end
          end
          break
        end
      end
      if not hasItem then
        table.insert(oldOnly, oldItem)
      end
    end

    for newName, newItem in pairs(new) do
      local hasItem = false
      for oldName, oldItem in pairs(old) do
        if oldName == newName then
          hasItem = true
          break
        end
      end
      if not hasItem then
        table.insert(newOnly, newItem)
        if newItem.type == "dir" then
          local newTable = {}
          local function addNewOnly(item)
            for _, item in pairs(item) do
              if item.type == "dir" then
                addNewOnly(item.child)
               else
                table.insert(newTable, item)
              end
            end
          end
          addNewOnly(newItem.child)
          for _, item in ipairs(newTable) do
            table.insert(newOnly, item)
          end
        end
      end
    end
  end
  compare(old, new)
  --写入文件(patht.."oldOnly.txt", dump(oldOnly))
  --写入文件(patht.."newOnly.txt", dump(newOnly))
  --写入文件(patht.."oldNewer.txt", dump(oldNewer))
  --写入文件(patht.."newNewer.txt", dump(newNewer))
  return oldOnly, newOnly, oldNewer, newNewer
end

function updateMetaData(which, path, new)
  if File(which).isFile() then
    local oldTree = cjson.decode(读取文件(which))
    local newTree = updateTree(oldTree, path, new)
    写入文件(which, cjson.encode(newTree))
  end
end

function updateWebdavInfoOnly()
  --[[local ipInfo = {}
  if File(pathc.."LastIPInfo.json").isFile() then
    ipInfo = cjson.decode(读取文件(pathc.."LastIPInfo.json"))
  end]]
  写入文件(pathc.."WebdavInfo.json",cjson.encode({
    time=System.currentTimeMillis(),
    deviceInfo=deviceInfo,
    --ipInfo=ipInfo,
    version=4
  }))
end

function updateWebdavInfo(new)
  updateWebdavInfoOnly()
  updateMetaData(pathc.."MetaData.json", pathn, new)
end

function updateTreeFromTree(oldTree, newTree, base, newItems)
  local function tree(oldTree, newTree)
    local resultTree = newTree
    for oldName, oldItem in pairs(oldTree) do
      for newName, newItem in pairs(newTree) do
        if oldName == newName then
          if oldItem.type == newItem.type then
            --type相同
            if oldItem.type == "file" then
              --均为file
              if oldItem.time ~= newItem.time then
                for _, item in ipairs(newItems) do
                  if item.path == oldItem.path then
                    resultTree[newName].time = oldItem.time
                  end
                end
              end
             else
              --均为dir
              local dirTree = tree(oldItem.child, newItem.child)
              resultTree[newName].child = dirTree
            end
          end
        end
      end
    end
    return resultTree
  end
  local resultTree = tree(oldTree, newTree)
  --写入文件(patht.."test.txt",dump(resultTree))
  return resultTree
end

function mergeTrees(oldTree, newTree)
  local function tree(oldTree, newTree)
    local resultTree = oldTree

    for newName, newItem in pairs(newTree) do
      local hasItem = false
      for oldName, oldItem in pairs(oldTree) do
        if oldName == newName then
          hasItem = true
          break
        end
      end
      if not hasItem then
        resultTree[newName] = newItem
      end
    end

    for oldName, oldItem in pairs(oldTree) do
      for newName, newItem in pairs(newTree) do
        if oldName == newName then
          if oldItem.type == newItem.type then
            --type相同
            if oldItem.type == "file" then
              --均为file
              resultTree[newName] = newItem
             else
              --均为dir
              local dirTree = tree(oldItem.child, newItem.child)
              resultTree[newName].child = dirTree
            end
           else
            --type不同
            resultTree[newName] = newItem
          end
        end
      end
    end
    return resultTree
  end
  local resultTree = tree(oldTree, newTree)
  --写入文件(patht.."test.json",cjson.encode(resultTree))
  return resultTree
end

function px2dp(pxValue)
  local scale = this.getResources().getDisplayMetrics().density
  return (pxValue / scale + 0.5)
end

function dp2px(dpValue)
  local scale = this.getResources().getDisplayMetrics().density
  return (dpValue * scale + 0.5)
end


function viewToBitmap(view)
  local width = view.getWidth()
  local height = view.getHeight()
  local bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
  local canvas = Canvas(bitmap)
  canvas.drawColor(COLOR_MAIN_BACKGROUND)
  view.draw(canvas)
  return bitmap
end

function webviewToBitmap(webView, func)
  webView.measure(View.MeasureSpec.makeMeasureSpec(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED))
  webView.layout(0, 0, webView.getMeasuredWidth(), webView.getMeasuredHeight())
  webView.setDrawingCacheEnabled(true)
  webView.buildDrawingCache(false)
  local bitmap = Bitmap.createBitmap(webView.getMeasuredWidth(), webView.getMeasuredHeight(), Bitmap.Config.ARGB_8888)
  task(1, function()
    local canvas = Canvas(bitmap)
    local paint = Paint()
    local iHeight = bitmap.getHeight()
    canvas.drawBitmap(bitmap, 0, iHeight, paint)
    webView.draw(canvas)
    webView.setDrawingCacheEnabled(false)
    func(bitmap)
  end)
end

function bitmapToFile(bitmap, path)
  local file = File(path)
  if file.exists() then
    if not file.isFile() then
      file.delete()
      file.createNewFile()
    end
   else
    file.getParentFile().mkdirs()
    file.createNewFile()
  end
  local fos = FileOutputStream(file)
  bitmap.compress(Bitmap.CompressFormat.JPEG, 90, fos)
  fos.flush()
  fos.close()
  bitmap.recycle()
end
