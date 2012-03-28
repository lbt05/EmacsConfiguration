;;;; Basic setup: colors, modifier keys, builtin behaviors, etc.
(setq kill-whole-line t)
(setq confirm-kill-emacs 'yes-or-no-p)
(delete-selection-mode)
(random t)                              ; reseed
(server-start)
(global-auto-revert-mode 1)
(set-cursor-color "black")

(global-set-key [(f6)] 'next-error)
(global-set-key [(shift f6)] 'previous-error)
;; on kinesis freestyle, 'Delete' sends kp-delete
(global-set-key [kp-delete] 'delete-char)
(global-set-key [(control kp-delete)] 'kill-word)

;; Mac-isms. They do no harm on non-macs.
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

;; don't iconify on C-z when running in X
;; or exit emacs (!) when running in Emacs.app
(when window-system (global-unset-key "\C-z"))

;; while I <square box> Unicode as much as the next guy,
;; I want my lambdas left alone.
(remove-hook 'coding-hook 'pretty-lambdas)

;; just nice to have everywhere; my screen is only so wide
(add-hook 'coding-hook (lambda () (setq tab-width 2)))

;; bar cursor makes it easier to see what delete-(backward-)char are going to hit
(add-to-list 'load-path "~/.emacs.d/vendor/bar-cursor")
(require 'bar-cursor)
(bar-cursor-mode 1)

;;;; line numbers on the left in a gui
(when window-system
  (add-to-list 'load-path "~/.emacs.d/vendor/linum")
  (require 'linum)
  (global-linum-mode 1))

;;;; Extra packages that the starter kit doesn't give us
(setq starter-kit-packages
      (append starter-kit-packages (list 'yasnippet-bundle
                                         'clojure-mode
                                         'slime
                                         'slime-repl
                                         'paredit
                                         'haml-mode
                                         'sass-mode
                                         'slime)))
(starter-kit-elpa-install)

(add-hook 'haml-mode-hook
          (lambda ()
            (run-hooks 'coding-hook)))

(add-to-list 'load-path "~/.emacs.d/vendor/el-expectations")
(require 'yaml-mode)

(add-to-list 'load-path "~/.emacs.d/vendor/clojure-mode")
(require 'clojure-mode)

(add-to-list 'load-path "~/.emacs.d/vendor/rpm-spec-mode")
(autoload 'rpm-spec-mode "rpm-spec-mode.el" "RPM spec mode." t)
(setq auto-mode-alist (append '(("\\.spec" . rpm-spec-mode))
			       auto-mode-alist))

;;;; tab-completion configuration (hooray hippie-expand)
(setq hippie-expand-try-functions-list (cons 'yas/hippie-try-expand hippie-expand-try-functions-list))
(global-set-key [(shift tab)] 'hippie-expand)
(global-set-key [(control tab)] 'hippie-expand)

;;;; TRAMP configuration
;; ssh is faster than scp for the small files I usually edit
;; remotely.
(setq tramp-default-method "ssh")

;;;; puppet-mode for editing puppet *.pp files
(add-to-list 'load-path "~/.emacs.d/vendor/puppet-mode")
(load "puppet-mode-init.el")
(add-hook 'puppet-mode-hook
          (lambda ()
            (run-hooks 'coding-hook)))

;;;; js-mode for javascript, not espresso-mode (espresso-mode is old
;;;; and busted)
(setq auto-mode-alist (append '(("\\.js" . js-mode))
                              auto-mode-alist))
(add-hook 'js-mode-hook
          (lambda ()
            (run-hooks 'coding-hook)))
(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)))

;;;; spiffy-mode provides a few utilities
(add-to-list 'load-path "~/.emacs.d/vendor/spiffy")
(setq spiffy-enable-minor-mode t)
(require 'spiffy)

;;;; spiffy-textmate-mode has some good stuff, but I don't want the
;;;; full minor mode since it stomps all over a bunch of default keybindings
(require 'spiffy-textmate-mode)
(add-hook 'coding-hook
          (lambda ()
            (local-set-key [f5] 'spiffy-tm-grep-project)
            (local-set-key [f8] 'spiffy-tm-open-file-in-project)
            (local-set-key [(control x) ?4 f8] 'spiffy-tm-open-file-in-project-other-window)))

;;;; configuration chunks too large to just jam in here
(require 'custom-ruby)
(require 'custom-color-compilation)
(require 'custom-causes)
