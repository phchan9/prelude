;; required extra package
(prelude-require-packages '(neotree js2-refactor ag xref-js2
                                    zerodark-theme tern
                                    exec-path-from-shell
                                    company-tern rjsx-mode
                                    yasnippet))

;; disable flycheck mode, (setq prelude-flyspell nil) not work
;; need to dive it to find the problem
(global-flycheck-mode 0)

;; set ui properly when start session from daemon
(defun ph-set-ui-daemon (frame)
  (select-frame frame)
  (ph-set-ui))

(defun ph-set-ui ()
  (if (equal system-type 'darwin)
      (set-frame-font "Courier 16")
    (set-frame-font "Monospace 16"))
  (load-theme 'zerodark t))

;; fix incorrect size of font and colorscheme when open emacsclient
;; session from emacs-daemon
(if (daemonp)
    (add-hook 'after-make-frame-functions 'ph-set-ui-daemon)
  (ph-set-ui))

;; Accoring to perlude-custom.el, I can define this variable as a
;; personal usage
(setq prelude-user-init-file load-file-name)

(defun ph-open-my-custom-file ()
  "Edit the `ph-custom-file`, in another window. If there is
is only one visible window, it will split another one window
at right"
  (interactive)
  (split-window-right)
  (find-file-other-window prelude-user-init-file))

;; set global keybinding
(global-set-key (kbd "C-c 1") 'ph-open-my-custom-file)

(if (equal system-type 'darwin)
    (global-set-key (kbd "C-c C-f 1") 'toggle-frame-fullscreen))

;; set rainbow mode to css hook
(add-hook 'css-mode-hook 'rainbow-mode)

;; set linum mode
(global-linum-mode 1)

;; set visual line mode
(global-visual-line-mode 1)

;; set auto pair
(electric-pair-mode 1)

;; set neotree keybinding
(global-set-key (kbd "<f8>") 'neotree-toggle)
(setq projectile-switch-project-action 'neotree-projectile-action)
(setq neo-theme 'ascii)

;; set exec-path consist with PATH environment variable
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; init company mode globally
(add-hook 'after-init-hook 'global-company-mode)

;; use this link to configure js2-refactor and xref-js2
;; https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html
(require 'js2-refactor)
(require 'xref-js2)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; better imenu for js2 mode
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with
;; xref, so unbind it.
(define-key js-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
                           (add-hook 'xref-backend-functions
                                     #'xref-js2-xref-backend nil t)
                           (setq js2-basic-offset 2)))

;; setup company with backend tern mode
(require 'company)
(require 'company-tern)

(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))

;; Disable completion keybindings and tern-rename-variable function, as we use xref-js2 instead
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)
(define-key tern-mode-keymap (kbd "C-c C-r") nil)

;; rxjs mode for react development
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; enable yasnippet and set personal snippet path
(defvar ph-personal-snippet-dir (expand-file-name "snippets" prelude-personal-dir)
  "This directory is for my personal snippets.")
(require 'yasnippet)
(setq yas-snippet-dirs (cons ph-personal-snippet-dir (cdr yas-snippet-dirs)))
(yas-global-mode 1)

;; start emacs server
(server-start)

(provide 'ph-custom)
;;; ph-custom.el ends here
