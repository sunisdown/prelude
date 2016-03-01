;;; prelude-ui.el --- Emacs Prelude: UI optimizations and tweaks.
;;
;; Copyright © 2011-2016 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: https://github.com/bbatsov/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; We dispense with most of the point and click UI, reduce the startup noise,
;; configure smooth scolling and a nice theme that's easy on the eyes (zenburn).

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; 没有 menubar
(menu-bar-mode -1)

(if window-system
    (progn
      ;; 控制是否显示行号和内容容器直接的间隔
      (set-fringe-style 0)
      ;; 控制 tip 是否在 minibuffer 显示（-1 为显示）
      (tooltip-mode t)
      ;; 没有 toolbar
      (tool-bar-mode -1)
      ;; 光标不闪，不恍花眼睛
      (blink-cursor-mode -1)
      (transient-mark-mode t)
      ;; 没有滚动条 24.1
      (scroll-bar-mode -1)
    ))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
;; 关闭启动时的 “开机画面”
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
;; 显示列号
(column-number-mode t)
(size-indication-mode t)
;; 显示行号
(global-linum-mode t)
;; 调整行号栏的格式
(setq linum-format "%3d ")
;; 括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号。
(show-paren-mode t)
(setq show-paren-style 'parentheses)
;; 让 Emacs 可以直接打开和显示图片。
(auto-image-file-mode t)
;;语法加亮
(global-font-lock-mode t)
;; 显示时间
(display-time)
;; 时间的格式
(setq display-time-format "%H:%M @ %m.%d")
;; 时间的变化频率
(setq display-time-interval 10)
;; 在标题栏显示buffer的名字，而不是 emacs@email.***这样没用的提示。
(setq frame-title-format "Emacs@%b")


;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '("" invocation-name " Prelude - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

;; use zenburn as the default theme
(when prelude-theme
  (load-theme prelude-theme t))

(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
;; delegate theming to the currently active theme
(setq sml/theme nil)
(add-hook 'after-init-hook #'sml/setup)

;; show the cursor when moving after big movements in the window
(require 'beacon)
(beacon-mode +1)

(provide 'prelude-ui)
;;; prelude-ui.el ends here
