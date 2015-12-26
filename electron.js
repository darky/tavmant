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
      label: 'Редактирование',
      submenu: [
        {
          label: 'Отменить',
          accelerator: 'CmdOrCtrl+Z',
          role: 'undo'
        },
        {
          label: 'Повторить',
          accelerator: 'Shift+CmdOrCtrl+Z',
          role: 'redo'
        },
        {
          type: 'separator'
        },
        {
          label: 'Вырезать',
          accelerator: 'CmdOrCtrl+X',
          role: 'cut'
        },
        {
          label: 'Копировать',
          accelerator: 'CmdOrCtrl+C',
          role: 'copy'
        },
        {
          label: 'Вставить',
          accelerator: 'CmdOrCtrl+V',
          role: 'paste'
        },
        {
          label: 'Выделить всё',
          accelerator: 'CmdOrCtrl+A',
          role: 'selectall'
        },
      ]
    },
    {
      label: 'Вид',
      submenu: [
        {
          label: 'Перезагрузить',
          accelerator: 'CmdOrCtrl+R',
          click: function(item, focusedWindow) {
            if (focusedWindow)
              focusedWindow.reload();
          }
        },
        {
          label: 'Полный экран',
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
      label: 'Окно',
      role: 'window',
      submenu: [
        {
          label: 'Минимизировать',
          accelerator: 'CmdOrCtrl+M',
          role: 'minimize'
        },
        {
          label: 'Закрыть',
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
          label: 'Скрыть Tavmant',
          accelerator: 'Command+H',
          role: 'hide'
        },
        {
          label: 'Скрыть другие',
          accelerator: 'Command+Shift+H',
          role: 'hideothers'
        },
        {
          label: 'Показать все',
          role: 'unhide'
        },
        {
          type: 'separator'
        },
        {
          label: 'Выйти',
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
        label: 'Все перед',
        role: 'front'
      }
    );
  }

  var menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);

  mainWindow = new BrowserWindow({
    title : "Tavmant"
  });
  mainWindow.loadURL('file://' + __dirname + '/index.html');
  mainWindow.focus();
});
