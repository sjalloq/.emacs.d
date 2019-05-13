(add-to-list 'load-path "~/.emacs.d/lisp")

(show-paren-mode)

;; ----------------------------------------------------------------------
;; Verilog Mode
;; ----------------------------------------------------------------------

(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))

;; Keep any Verilog mode user additions in a separate file so that we can
;; update verilog-mode.el without losing functionality.
(with-eval-after-load "verilog-mode" (load-file "~/.emacs.d/lisp/verilog-custom.el"))

;; Enable syntax highlighting of **all** languages
(global-font-lock-mode t)

;; User customization for Verilog mode
(setq verilog-indent-level             3
      verilog-indent-level-module      3
      verilog-indent-level-declaration 3
      verilog-indent-level-behavioral  3
      verilog-indent-level-directive   1
      verilog-case-indent              2
      verilog-auto-newline             t
      verilog-auto-indent-on-newline   t
      verilog-tab-always-indent        t
      verilog-auto-endcomments         t
      verilog-minimum-comment-distance 40
      verilog-indent-begin-after-if    t
      verilog-auto-lineup              'declarations
      verilog-linter                   "my_lint_shell_command"
      )


;; ----------------------------------------------------------------------
;; Minor Mode
;; ----------------------------------------------------------------------

;; Create a minor mode to which we can assign key bindings.  Using
;; global-set-key doesn't always work as any local-mode, minor-mode
;; or major-mode settings take priority.

;; Create a key map to which we can define key bindings
(defvar verilog-minor-mode-map (make-sparse-keymap)
  "Keymap for `verilog-minor-mode'.")

;;;###autoload
(define-minor-mode verilog-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-verilog-minor-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter " verilog-minor-mode"
  :keymap verilog-minor-mode-map)

;;;###autoload
(define-globalized-minor-mode global-verilog-minor-mode verilog-minor-mode verilog-minor-mode)

;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;; The keymaps in `emulation-mode-map-alists' take precedence over
;; `minor-mode-map-alist'
(add-to-list 'emulation-mode-map-alists `((verilog-minor-mode . ,verilog-minor-mode-map)))

;; Turn off the minor mode in the minibuffer
(defun turn-off-verilog-minor-mode ()
  "Turn off verilog-minor-mode."
  (verilog-minor-mode -1))
(add-hook 'minibuffer-setup-hook #'turn-off-verilog-minor-mode)

(provide 'verilog-minor-mode)


;; ----------------------------------------------------------------------
;; Key Bindings
;; ----------------------------------------------------------------------

;; Attach all key bindings to the minor mode, verilog-minor-mode, so that
;; they overwrite the default bindings.

(define-key verilog-minor-mode-map (kbd "<f1>" ) 'verilog-insert-module)
(define-key verilog-minor-mode-map (kbd "<f11>") 'verilog-comment-region)
(define-key verilog-minor-mode-map (kbd "<f12>") 'verilog-uncomment-region)

(define-key verilog-minor-mode-map (kbd "<f10>") 'revert-buffer)
