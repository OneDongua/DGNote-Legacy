require "import"
import "libs/util"

function onStart()
  task(function()
    local success, errorMsg = pcall(function()
      import "libs/util"
      res=0

      local local_conf=pathc.."WebdavConfig.json"

      local local_info=pathc.."WebdavInfo.json"
      local cache_info=patht.."WebdavInfo.json"
      local local_meta=pathc.."MetaData.json"
      local cache_meta=patht.."MetaData.json"

      local local_last_info=pathc.."LastWebdavInfo.json"

      local notePath="冬瓜便签/便签/"
      local confPath="冬瓜便签/配置文件/"
      local timePath=confPath.."快速更新文件/"

      local dav_info=confPath.."WebdavInfo.json"
      local dav_meta=confPath.."MetaData.json"

      if File(local_conf).isFile() then
        --配置文件存在
        local conf=cjson.decode(读取文件(local_conf))
        Webdav.new(conf)

        local _success, _err = pcall(function()
          if not Webdav.exists(timePath) then
            Webdav.createDir("冬瓜便签")
            Webdav.createDir(notePath)
            Webdav.createDir(confPath)
            Webdav.createDir(timePath)
          end
        end)
        if not _success then
          Webdav.createDir("冬瓜便签")
          Webdav.createDir(notePath)
          Webdav.createDir(confPath)
          Webdav.createDir(timePath)
        end

        if Webdav.exists(dav_meta) then
          --远程有2版meta
          local davTimeTable = Webdav.list(timePath)
          local davTime
          local davTimePath
          if next(davTimeTable) then
            --远程有2版快速更新文件
            davTimePath = tostring(davTimeTable[#davTimeTable])
            davTime = tonumber(tostring(davTimeTable[#davTimeTable]):match("[%d%.]+$"))
           else
            Webdav.downloadFile(dav_info, cache_info)
            davTime = cjson.decode(读取文件(cache_info)).time
          end
          if File(local_meta).isFile() then
            --本地有2版meta(必有)
            local localTree = cjson.decode(读取文件(local_meta))
            if File(local_info).isFile() then
              --本地有信息
              local localTime = cjson.decode(读取文件(local_info)).time
              if davTime == localTime then
                --同步时间相等
                res=3
               else
                --同步时间不相等
                Webdav.downloadFile(dav_meta, cache_meta)
                local davTree = cjson.decode(读取文件(cache_meta))
                if davTime > localTime then
                  --远程较新
                  local oldOnly, newOnly, oldNewer, newNewer = compareTrees(localTree, davTree)
                  for _, item in ipairs(oldOnly) do
                    os.execute("rm -rf \""..pathn..item.path.."\"")
                  end
                  for _, item in ipairs(newOnly) do
                    if item.type == "dir" then
                      File(pathn..item.path).mkdirs()
                     else
                      Webdav.downloadFile(notePath..item.path, pathn..item.path)
                    end
                  end
                  for _, item in ipairs(oldNewer) do
                    Webdav.uploadFile(notePath..item.parentPath, pathn..item.path)
                  end
                  for _, item in ipairs(newNewer) do
                    Webdav.downloadFile(notePath..item.path, pathn..item.path)
                  end
                  if next(oldNewer) then
                    local newTree = updateTreeFromTree(localTree, davTree, pathn, oldNewer)
                    写入文件(cache_meta, cjson.encode(newTree))
                    Webdav.uploadFile(confPath, cache_meta)
                    os.rename(cache_meta, local_meta)
                    updateWebdavInfoOnly()
                    Webdav.uploadFile(confPath, local_info)
                    localTime = math.floor(cjson.decode(读取文件(local_info)).time)
                    if davTimePath then
                      Webdav.move(davTimePath, timePath..localTime)
                     else
                      local cache_time = patht..tostring(localTime)
                      File(cache_time).createNewFile()
                      Webdav.uploadFile(timePath, cache_time)
                      os.remove(cache_time)
                    end
                   else
                    os.rename(cache_meta, local_meta)
                    Webdav.downloadFile(dav_info, local_info)
                  end
                  os.execute("cp -f \""..local_info.."\" \""..local_last_info.."\"")
                  res=6
                 else
                  --本地较新
                  local oldOnly, newOnly, oldNewer, newNewer = compareTrees(davTree, localTree)
                  for _, item in ipairs(oldOnly) do
                    Webdav.delete(notePath..item.path)
                  end
                  for _, item in ipairs(newOnly) do
                    if item.type == "dir" then
                      Webdav.createDir(notePath..item.path)
                     else
                      Webdav.uploadFile(notePath..item.parentPath, pathn..item.path)
                    end
                  end
                  for _, item in ipairs(oldNewer) do
                    Webdav.downloadFile(notePath..item.path, pathn..item.path)
                  end
                  for _, item in ipairs(newNewer) do
                    Webdav.uploadFile(notePath..item.parentPath, pathn..item.path)
                  end
                  if next(oldNewer) then
                    local newTree = updateTreeFromTree(davTree, localTree, pathn, oldNewer)
                    写入文件(local_meta, cjson.encode(newTree))
                    updateWebdavInfoOnly()
                  end
                  Webdav.uploadFile(confPath, local_meta)
                  Webdav.uploadFile(confPath, local_info)
                  localTime = math.floor(cjson.decode(读取文件(local_info)).time)
                  if davTimePath then
                    Webdav.move(davTimePath, timePath..localTime)
                   else
                    local cache_time = patht..tostring(localTime)
                    File(cache_time).createNewFile()
                    Webdav.uploadFile(timePath, cache_time)
                    os.remove(cache_time)
                  end
                  os.execute("cp -f \""..local_info.."\" \""..local_last_info.."\"")
                  res=5
                end
              end
             else
              --本地无信息
              Webdav.downloadFile(dav_meta, cache_meta)
              local davTree = cjson.decode(读取文件(cache_meta))
              local function dlMetaAll(tree)
                for name, item in pairs(tree) do
                  if item.type == "dir" then
                    File(pathn..item.path).mkdirs()
                    dlMetaAll(item.child)
                   else
                    Webdav.downloadFile(notePath..item.path, pathn..item.path)
                  end
                end
              end
              dlMetaAll(davTree)
              os.rename(cache_meta, local_meta)
              Webdav.downloadFile(dav_info, local_info)
              os.execute("cp -f \""..local_info.."\" \""..local_last_info.."\"")
              res=2
            end

          end
         else
          --远程无2版meta (1版/未同步过)
          if File(local_meta).isFile() then
            --本地有2版meta(必有)
            local localTree = cjson.decode(读取文件(local_meta))

            local function dlAll()
              for k,v in ipairs(Webdav.list(notePath)) do
                if tostring(v):match("冬瓜便签/便签/(.+)") then
                  Webdav.downloadFile(tostring(v),pathn..tostring(v):match("冬瓜便签/便签/(.+)"))
                end
              end
            end

            local function ulAll()
              local ls=luajava.astable(File(pathn).listFiles())
              local noteList={}
              if next(ls)~=nil then
                for k,v in ipairs(ls) do
                  if v.isFile() then
                    table.insert(noteList,v)
                  end
                end
                for k,v in ipairs(noteList) do
                  Webdav.uploadFile(notePath,v.getAbsolutePath())
                end
              end
            end

            --旧版同步
            if Webdav.exists(dav_info) then
              --远程有信息
              if File(local_info).isFile() then
                --本地有信息
                Webdav.downloadFile(dav_info,cache_info)
                local localInfo=cjson.decode(读取文件(local_info))
                local webdavInfo=cjson.decode(读取文件(cache_info))

                if localInfo.time > webdavInfo.time then
                  --本地较新
                  local davList=Webdav.list(notePath)
                  local localList=luajava.astable(File(pathn).listFiles())

                  local davNoteList={}
                  local localNoteList={}

                  for k,v in ipairs(davList) do
                    table.insert(davNoteList,tostring(v):match("冬瓜便签/便签/(.+)"))
                  end

                  for k,v in ipairs(localList) do
                    if v.isFile() then
                      table.insert(localNoteList,v.getName())
                    end
                  end

                  local davOnly,localOnly,both=compareTables(davNoteList,localNoteList)

                  for k,v in ipairs(davOnly) do
                    Webdav.delete(tostring(notePath..v))
                  end

                  for k,v in ipairs(localOnly) do
                    Webdav.uploadFile(notePath,pathn..v)
                  end

                  for k,v in ipairs(both) do
                    local davDate=webdavInfo.time
                    local localDate=File(pathn..v).lastModified()

                    if davDate>localDate then
                      Webdav.downloadFile(tostring(notePath..v),pathn..v)
                     elseif davDate<localDate then
                      Webdav.uploadFile(notePath,pathn..v)
                    end
                  end

                  Webdav.uploadFile(confPath,local_info)
                  res=5

                 elseif localInfo.time < webdavInfo.time then
                  --远程较新
                  local davList=Webdav.list(notePath)
                  local localList=luajava.astable(File(pathn).listFiles())

                  local davNoteList={}
                  local localNoteList={}

                  for k,v in ipairs(davList) do
                    table.insert(davNoteList,tostring(v):match("冬瓜便签/便签/(.+)"))
                  end

                  for k,v in ipairs(localList) do
                    if v.isFile() then
                      table.insert(localNoteList,v.getName())
                    end
                  end

                  local davOnly,localOnly,both=compareTables(davNoteList,localNoteList)

                  for k,v in ipairs(davOnly) do
                    Webdav.downloadFile(tostring(notePath..v),pathn..v)
                  end

                  for k,v in ipairs(localOnly) do
                    os.remove(pathn..v)
                  end

                  for k,v in ipairs(both) do
                    local davDate=webdavInfo.time
                    local localDate=File(pathn..v).lastModified()

                    if davDate>localDate then
                      Webdav.downloadFile(tostring(notePath..v),pathn..v)
                     elseif davDate<localDate then
                      Webdav.uploadFile(notePath,pathn..v)
                    end
                  end

                  Webdav.downloadFile(dav_info,local_info)
                  res=6
                 else
                  --时间相同
                  res=3
                end
               else
                --本地无信息
                dlAll()
                Webdav.downloadFile(dav_info,local_info)
                res=2
              end
             else
              --远程无信息(未同步过)(新版)
              if File(local_info).isFile() then
                --本地有信息
                local localTime = cjson.decode(读取文件(local_info)).time
                local function ulMetaAll(tree)
                  for name, item in pairs(tree) do
                    if item.type == "dir" then
                      Webdav.createDir(notePath..item.path)
                      ulMetaAll(item.child)
                     else
                      Webdav.uploadFile(notePath..item.parentPath, pathn..item.path)
                    end
                  end
                end
                ulMetaAll(localTree)
                Webdav.uploadFile(confPath, local_meta)
                Webdav.uploadFile(confPath, local_info)
                local cache_time = patht..tostring(math.floor(localTime))
                File(cache_time).createNewFile()
                Webdav.uploadFile(timePath, cache_time)
                os.remove(cache_time)
                os.execute("cp -f \""..local_info.."\" \""..local_last_info.."\"")
                res=1
               else
                --本地无信息(两边为空)
                res=3
              end
            end
            --旧版同步完成
            --更新(除未同步过、无需同步)
            if res ~= 1 and res ~= 3 then
              local newTree = createTree(File(pathn))
              写入文件(pathc.."MetaData.json", cjson.encode(newTree))
              Webdav.uploadFile(confPath, local_meta)
              local localTime = cjson.decode(读取文件(local_info)).time
              local cache_time = patht..tostring(math.floor(localTime))
              File(cache_time).createNewFile()
              Webdav.uploadFile(timePath, cache_time)
              os.remove(cache_time)
              os.execute("cp -f \""..local_info.."\" \""..local_last_info.."\"")
              res=res+100
            end
          end
        end
       else
        --配置文件不存在
        res=4
      end
    end) --pcall

    if not success then
      res = debug.traceback(errorMsg)
    end

    return res
  end,
  function(res)
    import "android.content.Intent"
    local intent=Intent("sync")
    intent.setAction("com.onedongua.note.sync")
    intent.putExtra("result",res)
    this.sendBroadcast(intent)
  end) --task
end --onStart()


--[[1:全部上传
2:全部下载
3:无需操作
4:配置文件不存在
5:本地时间大于远程时间
6:远程时间大于本地时间
7:版本已过时
]]

--记得有关更改便签的函数添加updateWebdavInfo()
