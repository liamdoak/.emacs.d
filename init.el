;;; init.el - GNU Emacs user configuration file

;; Author: Liam Doak

;;; Commentary:

;; A basic configuration for GNU Emacs. It includes a custom color scheme, some
;; better defaults, and EVIL key bindings.

;;; Code:

;;;; Package:

;; prepare package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)


;; install use-package
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

;;;; Better Defaults:

;; turn off bell
(setq ring-bell-function 'ignore)

;; turn off safety files
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)

;; change coding system to utf-8
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;;;; Customization:

;; change custom file
(write-region "" nil "~/.emacs.d/custom.el")
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;; Visual:

;; highlight current line
(global-hl-line-mode 1)
(setq global-hl-sticky-flag nil)

;; highlight the column after column 80
(use-package hl-fill-column
    :init (setq-default fill-column 80)
    :ensure t
    :config (global-hl-fill-column-mode))

;; hide cursor in non-selected windows
(setq-default cursor-in-non-selected-windows nil)
(blink-cursor-mode 0)

;; show corresponding parenthesis, square bracket, angle bracket, or curly brace
(require 'paren)
(show-paren-mode)

;; change font
(set-face-attribute 'default nil :font "Liberation Mono-10")

;; GUI simplifications
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; set sytax highlighing
(set-background-color "#1C1C1C")
(set-foreground-color "#CCBC8A")
(set-cursor-color "#E7E7E7")
(set-face-attribute 'fringe nil :background "#1C1C1C")
(set-face-attribute 'fringe nil :foreground "#CCBC8A")
(set-face-attribute 'region nil :background "#393939")
(set-face-attribute 'highlight nil :background "#393939")
(set-face-attribute 'hl-fill-column-face nil :background "#CCBC8A")
(set-face-attribute 'hl-fill-column-face nil :foreground "#DE773D")
(set-face-attribute 'font-lock-builtin-face nil :foreground "#FFBB00")
(set-face-attribute 'font-lock-comment-face nil :foreground "#E7E7E7")
(set-face-attribute 'font-lock-constant-face nil :foreground "#CCBC8A")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "#CCBC8A")
(set-face-attribute 'font-lock-function-name-face nil :foreground "#CCBC8A")
(set-face-attribute 'font-lock-type-face nil :foreground "#B09053")
(set-face-attribute 'font-lock-keyword-face nil :foreground "#41BE47")
(set-face-attribute 'font-lock-string-face nil :foreground "#FF3336")
(set-face-attribute 'minibuffer-prompt nil :foreground "#A3DCAC")
(set-face-attribute 'show-paren-match nil :background "#DE773D")
(set-face-attribute 'show-paren-match nil :foreground "#CCBC8A")
(set-face-attribute 'isearch nil :background "#DE773D")
(set-face-attribute 'isearch nil :foreground "#CCBC8A")
(set-face-attribute 'lazy-highlight nil :background "#393939")
(set-face-attribute 'lazy-highlight nil :foreground "#CCBC8A")

;;;; Mode and Syntax Modifications:

;; require a newline at the end of a file
(setq-default require-final-newline t)

;; fix indentation
(c-set-offset 'arglist-cont-nonempty '+)
(c-set-offset 'arglist-intro '+)
(c-set-offset 'arglist-close '+)
(c-set-offset 'brace-list-intro '+)
(c-set-offset 'case-label '+)
(c-set-offset 'inextern-lang '-)
(c-set-offset 'statement-case-open 0)
(c-set-offset 'substatement-open 0)
(c-set-offset 'brace-list-open 0)

;; set indentation
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq lisp-indent-offset tab-width)
(setq c-basic-offset tab-width)
(setq rust-indent-offset tab-width)
(setq python-indent-offset tab-width)

;; rust
(use-package rust-mode
    :ensure t
    :config (require 'rust-mode))

;; GLSL
(use-package glsl-mode
    :ensure t
    :config
    (require 'glsl-mode)
    (add-hook 'glsl-mode-hook
        (lambda ()
            (setq-local electric-indent-chars '(?{ ?} ?\n))
            (setq-local electric-indent-inhibit nil))))

;; ninja
(use-package ninja-mode
    :ensure t
    :config (require 'ninja-mode))
    

;; turn on and set up EVIL mode
(use-package evil
    :ensure t
    :config
    (evil-mode)
    (setq evil-overriding-maps nil)
    (setq evil-intercept-maps nil))

;; bind keys with general
(use-package general
    :ensure t
    :config
    (general-define-key
        :states 'motion
        :prefix "F"
        "" nil)
    (general-define-key
        :states '(normal motion)
        "FF" 'delete-other-windows
        "Ff" 'evil-quit
        "FS" 'split-window-right
        "Fs" 'split-window-below
        "FI" 'open-init-file
        "FR" 'reload-init-file
        "FD" 'kill-buffer
        "zz" 'save-buffers-kill-emacs
        "J" 'scroll-up-command
        "K" 'scroll-down-command))

;;;; Startup:

;; turn off startup screen
(setq inhibit-startup-screen t)

;; change frame size
(when window-system
    (set-frame-size (selected-frame) 80 26))

;;;; Functions

;; function to open up "~/.emacs.d/init.el" in current window
(defun open-init-file ()
    (interactive)
    (find-file "~/.emacs.d/init.el"))

;; function to reload the init file to see changes immediately
(defun reload-init-file ()
    (interactive)
    (load "~/.emacs.d/init.el"))
