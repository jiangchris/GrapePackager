package grape.packager.menu
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
    import flash.filesystem.File;

import grape.packager.managers.FileManager;

import grape.packager.ui.AboutWindow;
import grape.packager.ui.Console;

import spark.components.Alert;

public class MenuManager
	{
		protected static var mPackagerMainMenu:NativeMenu = null;

        protected static var mFileMenu:NativeMenu = null;
		protected static var mExitMenuItem:NativeMenuItem = null;
		protected static var mCloseMenuItem:NativeMenuItem = null;
		protected static var mOpenConfigItem:NativeMenuItem = null;
		protected static var mSaveConfigItem:NativeMenuItem = null;
        protected static var mSaveASConfigItem:NativeMenuItem = null;
        protected static var mRecentOpenItem:NativeMenuItem = null;
		
		protected static var mOptionsMenu:NativeMenu = null;
        protected static var mSettingsMenuItem:NativeMenuItem = null;
        protected static var mPlatformsSettingMenuItem:NativeMenuItem = null;
		
		protected static var mHelpMenu:NativeMenu = null;
		protected static var mAboutMenuItem:NativeMenuItem = null;
		
		public function MenuManager(){}
		
		public static function getMainMenu():NativeMenu{
			if(!mPackagerMainMenu){
				
				mPackagerMainMenu = new NativeMenu();
				mFileMenu = new NativeMenu();
                mOptionsMenu = new NativeMenu();
				mHelpMenu = new NativeMenu();
				mPackagerMainMenu.addSubmenu(mFileMenu,"文件");
				mPackagerMainMenu.addSubmenu(mOptionsMenu,"选项");
				mPackagerMainMenu.addSubmenu(mHelpMenu,"帮助");
				
				mCloseMenuItem = new NativeMenuItem("关闭");
				mCloseMenuItem.keyEquivalent = "w";
				mCloseMenuItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
				mExitMenuItem = new NativeMenuItem("退出");
				mExitMenuItem.keyEquivalent = "q";
				mExitMenuItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
				mOpenConfigItem = new NativeMenuItem("打开配置");
				mOpenConfigItem.keyEquivalent = "o";
				mOpenConfigItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
				mSaveConfigItem = new NativeMenuItem("保存配置");
				mSaveConfigItem.keyEquivalent = "s";
				mSaveConfigItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
                mSaveASConfigItem = new NativeMenuItem("另存配置");
                mSaveASConfigItem.keyEquivalent = "S"
                mSaveASConfigItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
                mRecentOpenItem = new NativeMenuItem("最近打开");
                mRecentOpenItem.submenu = new NativeMenu();
                mRecentOpenItem.submenu.addEventListener(Event.DISPLAYING,onUpdateRecentOpenFileMenuHandler);

                mFileMenu.addItem(mOpenConfigItem);
				mFileMenu.addItem(mSaveConfigItem);
                mFileMenu.addItem(mSaveASConfigItem);
                mFileMenu.addItem(mRecentOpenItem);
				mFileMenu.addItem(mCloseMenuItem);
				mFileMenu.addItem(mExitMenuItem); 

                mSettingsMenuItem = new NativeMenuItem("设置");
                mSettingsMenuItem.keyEquivalent = "i";
                mSettingsMenuItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
                mPlatformsSettingMenuItem = new NativeMenuItem("第三方平台管理");
                mPlatformsSettingMenuItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
                mOptionsMenu.addItem(mSettingsMenuItem);
                mOptionsMenu.addItem(mPlatformsSettingMenuItem);

				mAboutMenuItem = new NativeMenuItem("关于");
				mAboutMenuItem.addEventListener(Event.SELECT,onMenuItemSelectedHandler);
				mHelpMenu.addItem(mAboutMenuItem);
			}
			return mPackagerMainMenu;
		}

        protected static function onUpdateRecentOpenFileMenuHandler(event:Event):void{
            trace("Updating recent document menu.");
            var docMenu:NativeMenu = NativeMenu(event.target);

            for each (var item:NativeMenuItem in docMenu.items) {
                docMenu.removeItem(item);
            }

            for each (var file:File in FileManager.getInstance().recentOpenFileList) {
                var menuItem:NativeMenuItem = docMenu.addItem(new NativeMenuItem(file.name));
                menuItem.data = file;
                menuItem.addEventListener(Event.SELECT, selectRecentDocument);
            }
        }

        private static function selectRecentDocument(event:Event):void {
            trace("Selected recent document: " + event.target.data.name);
	        var file:File = event.target.data;
	        if(!file.exists){
		        Console.getInstance().show("文件" + file.nativePath + "不存在!");
		        return;
	        }
	        GrapePackager.packagerTool.ReadConfigFile(event.target.data);
        }
		
		protected static function onMenuItemSelectedHandler(event:Event):void
		{
			switch(event.target){
				case mCloseMenuItem:
					NativeApplication.nativeApplication.exit();
					break;
				case mExitMenuItem:
					NativeApplication.nativeApplication.exit();
					break;
				case mOpenConfigItem:
					GrapePackager.packagerTool.OpenConfigFile();
					break;
				case mSaveConfigItem:
					GrapePackager.packagerTool.SaveConfigFile();
					break;
				case mAboutMenuItem:
					AboutWindow.show(GrapePackager.packagerTool);
					break;
                case mSettingsMenuItem:
                    GrapePackager.packagerTool.showSettingsPanel();
                    break;
                case mPlatformsSettingMenuItem:
                    break;
			}
		}
	}
}
