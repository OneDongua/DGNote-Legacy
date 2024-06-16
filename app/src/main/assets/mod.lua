require "import"
import "libs/util"

--版本号
local packinfo = activity.getPackageManager().getPackageInfo(this.getPackageName(),((1552294270/8/2-8392)/32/1250-25.25)/8-236)
ver = packinfo.versionName
verc = packinfo.versionCode

--应用包名与应用名称
packageName = this.getPackageName()
import "android.content.pm.PackageManager"
appName = activity.getPackageManager().getApplicationLabel(activity.getPackageManager().getApplicationInfo(packageName, PackageManager.GET_META_DATA))

--设置主题
--activity.setTheme(android.R.style.Theme_DeviceDefault_Light_NoActionBar)

--输入法
--(影响布局|始终隐藏)
--[[activity.getWindow().setSoftInputMode(
WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE |
WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN)]]
--(未定义)
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_UNSPECIFIED)

--状态栏可设色
--activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)

--导航栏沉浸
--activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
--activity.getWindow().setNavigationBarColor(Color.TRANSPARENT)

--创建通知渠道
if Build.VERSION.SDK_INT >= 26 then
  local manager = activity.getSystemService(Context.NOTIFICATION_SERVICE)
  local channel = NotificationChannel("0", "默认渠道", NotificationManager.IMPORTANCE_DEFAULT)
  manager.createNotificationChannel(channel)
  --[[local channel1 = NotificationChannel("1", "常驻渠道", NotificationManager.IMPORTANCE_MIN)
  manager.createNotificationChannel(channel1)]]
end

--function
function 设置视图(id)
  activity.setContentView(loadlayout(id))
end

function print(text)
  Toast.makeText(this,tostring(text),Toast.LENGTH_SHORT).show()
end

function 水波纹(id)
  local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray = activity.obtainStyledAttributes(attrsArray)
  local ripple = typedArray.getResourceId(0,0)
  local Pretend = activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{COLOR_MAIN_RIPPLE}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{COLOR_MAIN_RIPPLE})))
  id.onClick=function(view)
  end
end

function 波纹(id, color)
  local attrsArray = {android.R.attr.selectableItemBackgroundBorderless}
  local typedArray = activity.obtainStyledAttributes(attrsArray)
  local ripple = typedArray.getResourceId(0,0)
  local Pretend = activity.Resources.getDrawable(ripple)
  Pretend.setColor(ColorStateList(int[0].class{int{}},int{color}))
  id.setBackground(Pretend.setColor(ColorStateList(int[0].class{int{}},int{color})))
end

function 设置字体(id)
  local font = sharedData.font
  if font and font ~= "无" then
    id.setTypeface(Typeface.createFromFile(pathf..font))
  end
end

function update(force)
  local lastCheck = {}

  if File(patht.."update.json").isFile() then
    lastCheck = cjson.decode(读取文件(patht.."update.json"))
  end

  if lastCheck.date ~= os.date("%x") or force then
    local url="https://api.github.com/repos/OneDongua/DGNote-Update/releases/latest"
    Http.get(url, nil, "UTF-8", nil, function(code, content, cookie, header)
      if code == 200 then
        local logs = content:match("logs【(.-)】")
        local version = content:match("version【(.-)】")
        local versionCode = tonumber(content:match("versionCode【(%d-)】"))
        local link1 = content:match("link1【(.-)】")
        local pwd1 = content:match("pwd1【(.-)】")

        local contentTable = cjson.decode(content)
        local link2 = contentTable.assets[1].browser_download_url

        local update = {
          logs=logs,
          date=os.date("%x"),
          version=version,
          versionCode=versionCode,
          link1=link1,
          pwd1=pwd1,
          link2=link2
        }
        local json = cjson.encode(update)
        写入文件(patht.."update.json", json)

        if versionCode > verc then
          print("发现新版本"..version)
        end
      end
    end)
  end
end

