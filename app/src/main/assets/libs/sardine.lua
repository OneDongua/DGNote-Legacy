require "import"

import "com.thegrizzlylabs.sardineandroid.*"
import "com.thegrizzlylabs.sardineandroid.impl.*"

import "java.io.File"
import "okio.Okio"

Webdav={}

function Webdav.new(info)
  sardine=OkHttpSardine()
  sardine.setCredentials(info.account,info.password)
  Webdav.info=info
  return Webdav
end

function Webdav.list(path)
  local root=Webdav.info.root
  local path=(path or "")
  local fullPath=root..path:gsub("/dav/","",1)
  local ls=sardine.list(fullPath)
  local tb=luajava.astable(ls)
  for k,v in ipairs(tb) do
    local v=tostring(v):gsub("/dav/","",1)
    if v == path or v.."/" == path or v == path.."/" then
      table.remove(tb,k)
    end
  end
  return tb
end

function Webdav.exists(path)
  local root=Webdav.info.root
  local path=root..path:gsub("/dav/","",1)
  return sardine.exists(path)
end

function Webdav.getModified(path) --返回Date类
  local root=Webdav.info.root
  local path=root..path:gsub("/dav/","",1)
  return sardine.list(path).get(0).getModified()
end

function Webdav.createDir(path) --目录结尾带不带/都行
  local root=Webdav.info.root
  local path=root..path:gsub("/dav/","",1)
  sardine.createDirectory(path)
  --return sardine.exists(path)
end

function Webdav.delete(path) --目录结尾带不带/都行
  local root=Webdav.info.root
  local path=root..path:gsub("/dav/","",1)
  sardine.delete(path)
  --return not sardine.exists(path)
end

function Webdav.move(pathFrom, pathTo)
  local root=Webdav.info.root
  local pathFrom=root..pathFrom:gsub("/dav/","",1)
  local pathTo=root..pathTo:gsub("/dav/","",1)
  sardine.move(pathFrom, pathTo)
  --return sardine.exists(pathTo)
end

function Webdav.uploadFile(path,localpath) --path不带文件名，结尾带不带/都行
  local root=Webdav.info.root
  local path=root..path:gsub("/dav/","",1)
  local function upload(path,localpath)
    if File(localpath).isFile() then
      if not sardine.exists(path) then
        sardine.createDirectory(path);
      end
      local bytes=Okio.buffer(Okio.source(File(localpath))).readByteArray();
      local function urlEncode(s)
        return s:gsub("([^%w%.%-/])", function(c) return string.format("%%%02X", string.byte(c)) end)
      end
      local path=path..urlEncode(File(localpath).getName())
      sardine.put(path,bytes)
    end
  end
  if path:sub(-1)~="/" then
    local path=path.."/"
    upload(path,localpath)
   else
    upload(path,localpath)
  end
  --return sardine.exists(path..File(localpath).getName())
end

function Webdav.downloadFile(path,localpath) --均带文件名
  local root=Webdav.info.root
  local path=root..path:gsub("/dav/","",1)
  local localParent=File(localpath).getParentFile()
  if not localParent.isDirectory() then
    localParent.mkdirs()
  end
  if path:sub(-1)~="/" and sardine.exists(path) then
    local is=sardine.get(path)
    local source=Okio.buffer(Okio.source(is))
    local sink=Okio.buffer(Okio.sink(File(localpath)))
    source.readAll(sink)
    source.close()
    sink.close()
  end
  --return File(localpath).isFile()
end
