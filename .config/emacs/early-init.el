;;; early-init.el --- Personal Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;;; UI Cleanup Modes (Disable visual clutter)
(tool-bar-mode -1)     ; Disable the toolbar.
(scroll-bar-mode -1)   ; Disable visible scrollbar.
(menu-bar-mode -1)     ; Disable the menu bar.
(tooltip-mode -1)      ; Disable tooltips.
(blink-cursor-mode -1) ; Disable cursor blink

(setq gc-cons-threshold 25000000)

;;; early-init.el ends here
