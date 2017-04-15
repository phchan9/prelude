;; set font size and font type
(set-frame-font "Monospace 16")

;; set key binding to open this my-custom file
(defvar ph-custom-dir (expand-file-name "personal" (file-name-directory user-init-file))
  "This directory is for phchang's customization.")

(defvar ph-custom-file (expand-file-name "ph-custom.el" ph-custom-dir)
  "This file is phchang's personal customization file.")

(defun ph-open-my-custom-file ()
  "Edit the `ph-custom-file`, in another window. If there is
is only one visible window, it will split another one window
at right"
  (interactive)
  (if (= (count-windows) 1)
      (split-window-right))
  (find-file-other-window ph-custom-file))

;; set global keybinding
(global-set-key (kbd "C-c 1") 'ph-open-my-custom-file)
(global-set-key (kbd "C-c C-f 1") 'toggle-frame-fullscreen)

;; set rainbow mode to css hook
(add-hook 'css-mode-hook 'rainbow-mode)

;; set linum mode
(global-linum-mode 1)

;; set visual line mode
(global-visual-line-mode 1)

;; set auto pair
(electric-pair-mode 1)

;; start emacs server
(server-start)

;; js setting for emacs, Reference by http://prak5190.github.io/p/jsemacs/
(require 'auto-complete)
; do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)
;; start yasnippet with emacs
(require 'yasnippet)
(yas-global-mode 1)

(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)))
(add-hook 'js2-mode-hook 'tern-mode)


(provide 'ph-custom)
;;; ph-custom.el ends here
