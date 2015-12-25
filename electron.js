const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;
const Menu = electron.Menu;

var mainWindow = null;

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  app.quit();
});

app.on('ready', function() {
  if (Menu.getApplicationMenu())
    return;

  var template = [
    {
      label: 'Edit',
      submenu: [
        {
          label: 'Undo',
          accelerator: 'CmdOrCtrl+Z',
          role: 'undo'
        },
        {
          label: 'Redo',
          accelerator: 'Shift+CmdOrCtrl+Z',
          role: 'redo'
        },
        {
          type: 'separator'
        },
        {
          label: 'Cut',
          accelerator: 'CmdOrCtrl+X',
          role: 'cut'
        },
        {
          label: 'Copy',
          accelerator: 'CmdOrCtrl+C',
          role: 'copy'
        },
        {
          label: 'Paste',
          accelerator: 'CmdOrCtrl+V',
          role: 'paste'
        },
        {
          label: 'Select All',
          accelerator: 'CmdOrCtrl+A',
          role: 'selectall'
        },
      ]
    },
    {
      label: 'View',
      submenu: [
        {
          label: 'Reload',
          accelerator: 'CmdOrCtrl+R',
          click: function(item, focusedWindow) {
            if (focusedWindow)
              focusedWindow.reload();
          }
        },
        {
          label: 'Toggle Full Screen',
          accelerator: (function() {
            if (process.platform == 'darwin')
              return 'Ctrl+Command+F';
            else
              return 'F11';
          })(),
          click: function(item, focusedWindow) {
            if (focusedWindow)
              focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
          }
        }
      ]
    },
    {
      label: 'Window',
      role: 'window',
      submenu: [
        {
          label: 'Minimize',
          accelerator: 'CmdOrCtrl+M',
          role: 'minimize'
        },
        {
          label: 'Close',
          accelerator: 'CmdOrCtrl+W',
          role: 'close'
        },
      ]
    }
  ];

  if (process.platform == 'darwin') {
    template.unshift({
      label: 'Tavmant',
      submenu: [
        {
          label: 'Hide Tavmant',
          accelerator: 'Command+H',
          role: 'hide'
        },
        {
          label: 'Hide Others',
          accelerator: 'Command+Shift+H',
          role: 'hideothers'
        },
        {
          label: 'Show All',
          role: 'unhide'
        },
        {
          type: 'separator'
        },
        {
          label: 'Quit',
          accelerator: 'Command+Q',
          click: function() { app.quit(); }
        },
      ]
    });
    template[3].submenu.push(
      {
        type: 'separator'
      },
      {
        label: 'Bring All to Front',
        role: 'front'
      }
    );
  }

  var menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);

  mainWindow = new BrowserWindow();
  mainWindow.loadURL('file://' + __dirname + '/index.html');
  mainWindow.focus();
});
