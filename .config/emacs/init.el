;;; init.el --- Personal Emacs configuration -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; Clamp down Emacs version to at least "30.2"
(when (version< emacs-version "30.2")
  (error "Need at least emacs 30.2"))

;;; Build-in packages
(use-package use-package
  :init
  (setq use-package-verbose t)
  (setq use-package-compute-statistics t))

(use-package use-package-ensure-system-package
  :after use-package)

(use-package package
  :config
  (add-to-list 'package-archives
	       '("melpa" .  "https://melpa.org/packages/") t))

(use-package emacs
  :custom
  (inhibit-startup-screen t "disable the startup screen")
  (use-short-answers t "uses shorter answers y or n")
  (ring-bell-function 'ignore "turn off bell")
  (vc-follow-symlinks t "follow symlinks without requesting confirmation.")
  (confirm-kill-emacs 'y-or-n-p "confirm before exiting emacs.")
  (use-file-dialog nil)
  (use-dialog-box nil)
  (fill-column 120)
  (delete-by-moving-to-trash t "move deleted files to trash")
  (electric-pair-mode t "enable automatic brackets pairing.")
  (column-number-mode t "show column numbers in modline.")
  (warning-minimum-level :error "only show errors in *warning* buffer. (maybe not so good)")
  :bind (("<escape>" . keyboard-escape-quit))
  :config
  (add-to-list 'default-frame-alist
	       '(font . "DejaVu Sans Mono-16:bold:italic"))
  (add-hook 'prog-mode-hook (lambda ()
			      (setq display-line-numbers 'relative)))

  (add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
  (require 'gptel-tools)

  ;; Move customization variables to a separate file and load it.
  (setq custom-file (expand-file-name "custom-vars.el" user-emacs-directory))
  (load custom-file 'noerror 'nomessage))

(use-package hl-line
  :hook
  ((prog-mode . hl-line-mode)
   (text-mode . hl-line-mode)))

(use-package whitespace
  :custom (whitespace-line-column nil "if nil, use the value of the ‘fill-column’ variable")
  :bind (("C-c w" . whitespace-mode)
	 ("C-c c" . whitespace-cleanup)))

(use-package icomplete
  :custom
  (fido-mode 1 "enable fido-mode"))

(use-package man
  :bind (("C-c m" . man)))

(use-package files
  :custom
  (backup-directory-alist '(("." . "~/.config/.saves")) "file backup directory")
  (delete-old-versions t "delete excess numbered backup files")
  (kept-new-versions 6 "number of newest versions to keep when a new numbered backup is made")
  (kept-old-versions 2 "number of oldest versions to keep when a new numbered backup is made")
  (version-control t "control use of version-numbered backup files"))

(use-package todo-mode
  :custom
  (todo-directory "~/vault/todo/")
  :bind (("C-c t" . todo-show)
	 ("C-c a" . todo-insert-item)
	 ("C-c j" . todo-jump-to-category)))

(use-package org
  :custom
  (org-hide-leading-stars t)
  (org-hide-emphasis-markers t)
  :hook ((org-mode . visual-line-mode))
  :custom-face
  (org-level-1 ((t (:height 1.35))))
  (org-level-2 ((t (:height 1.3))))
  (org-level-3 ((t (:height 1.2))))
  (org-level-4 ((t (:height 1.1))))
  (org-level-5 ((t (:height 1.1))))
  (org-level-6 ((t (:height 1.1))))
  (org-level-7 ((t (:height 1.1))))
  (org-level-8 ((t (:height 1.1)))))

(use-package eshell
  :custom (eshell-prefer-lisp-functions t "prefer lisp functions to external commands")
  :bind (("C-x e" . eshell))
  :config
  (require 'em-alias)
  (eshell/alias "ff" "find-file $1")
  (eshell/alias "d" "dired $1")
  (eshell/alias "cal" "calendar")
  (eshell/alias "la" "ls -ah")
  (eshell/alias "ll" "ls -ahl")
  (eshell/alias "c" "clear-scrollback"))

(use-package dired
  :custom
  (dired-listing-switches "-agho --ignore-backups --group-directories-first")
  (dired-dwim-target t)
  (dired-isearch-filenames t))

;;; modus-theme config

(use-package emacs
  :disabled
  :init
  (require-theme 'modus-themes)
  :bind (("<f5>" . modus-themes-toggle))
  :config
  (setq modus-themes-bold-constructs t
	modus-themes-italic-constructs t
	modus-themes-disable-other-themes t)

  (setq modus-themes-common-palette-overrides
	'((docstring green-faint)
	  (docmarkup magenta-faint)
	  (comment yellow-cooler)
	  (string green-cooler)))
  (modus-themes-load-theme 'modus-vivendi))

;;; External packages

(use-package gptel
  :pin melpa
  :ensure t
  :bind (("C-c g l" . gptel)
	 ("C-c g s" . gptel-send)
	 ("C-c g r" . gptel-rewrite)
	 ("C-c g m" . gptel-menu))
  :custom ((gptel-log-level 'info)
	   (gptel-track-media t)
	   (gptel-default-mode 'org-mode)
	   (gptel-system-prompt "You are a large language model living in Emacs.
 Your name is Fido, and you are a helpful assistant. Respond concisely.")
	   (gptel-include-reasoning "*reasoning-log*"))
  :hook ((gptel-post-stream . gptel-auto-scroll)
	 (gptel-post-response-functions . gptel-end-of-response)
	 (gptel-mode . gptel-highlight-mode))
  :config
  (setq gptel-model 'gemma4:latest
	gptel-backend (gptel-make-ollama "Fido"
			:host "localhost:11469"
			:stream t
			:request-params '(:keep_alive "15m"
						      :options (:num_ctx 16384))
			:models '(gemma4:latest qwen-uncensored-4B:latest))))

(use-package org-appear
  :pin melpa
  :ensure t
  :after org-mode
  :hook ((org-mode . org-appear-mode)))

(use-package system-packages
  :ensure t)

(use-package all-the-icons-dired
  :pin melpa
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package gruvbox-theme
  :pin nongnu
  :ensure t
  :preface
  (defun switch-theme ()
    (interactive)
    (let ((dark 'gruvbox-dark-hard)
	  (light 'gruvbox-light-hard))
      (cond ((memq dark custom-enabled-themes)
	     (disable-theme dark)
	     (load-theme light t))
	    ((memq light custom-enabled-themes)
	     (disable-theme light)
	     (load-theme dark t)))))
  :bind (("<f5>" . 'switch-theme))
  :config
  (load-theme 'gruvbox-dark-hard t)
  (require 'whitespace)
  (set-face-attribute 'whitespace-space nil
                      :foreground "#3c3836"))

(use-package slime
  :ensure-system-package sbcl
  :pin nongnu
  :ensure t
  :defer t
  :config
  (setq inferior-lisp-program "sbcl")
  (add-to-list 'slime-contribs 'slime-autodoc))

(use-package clhs
  :after slime
  :pin melpa
  :ensure t
  :config
  (load (concat (getenv "HOME") "/quicklisp/clhs-use-local.el") t nil))

(use-package paredit
  :pin nongnu
  :ensure t
  :hook ((slime-repl-mode . paredit-mode)
	 (lisp-mode       . paredit-mode)
	 (emacs-lisp-mode . paredit-mode)
	 (scheme-mode     . paredit-mode)))

(use-package rainbow-delimiters
  :pin nongnu
  :ensure t
  :hook ((lisp-mode       . rainbow-delimiters-mode)
	 (emacs-lisp-mode . rainbow-delimiters-mode)
	 (scheme-mode     . rainbow-delimiters-mode)))

(use-package multiple-cursors
  :pin nongnu
  :ensure t
  :bind (("C-c i"   . mc/edit-lines)
	 ("C->"	    . mc/mark-next-like-this)
	 ("C-<"	    . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)
	 ("C-c C->" . mc/mark-all-dwim)))

(use-package company
  :pin gnu
  :ensure t
  :hook
  ((prog-mode . company-mode)
   (text-mode . company-mode)))

(use-package magit
  :ensure-system-package git
  :pin nongnu
  :ensure t
  :defer t)

(use-package geiser-guile
  :pin nongnu
  :ensure t
  :defer t)

(use-package adoc-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package markdown-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package json-mode
  :pin gnu
  :ensure t)

(use-package rainbow-mode
  :pin gnu
  :ensure t
  :defer t)

(use-package go-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package lua-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package forth-mode
  :pin nongnu
  :ensure t
  :defer t)

(use-package nasm-mode
  :ensure-system-package nasm
  :pin nongnu
  :ensure t
  :defer t
  :mode ("\\.s\\'" "\\.S\\'" "\\.asm\\'" "\\.inc\\'"))

;;; init.el ends here
