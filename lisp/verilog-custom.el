;; Extra customisation for verilog mode.  This can be loaded when autoloading verilog-mode
;; by adding the following to your init.el file:
;;
;;     (with-eval-after-load "verilog-mode" (load-file "~/.emacs.d/lisp/verilog-custom.el"))

;; ----------------------------------------------------------------------
;; Number Processing
;; ----------------------------------------------------------------------

(defun dec->base ( n b )
  (if (< n b)
      (byte-to-string (+ n (if (< n 10) 48 55)))
    (concat (dec->base (/ n b) b) (dec->base (% n b) b))
    )
  )

(defun base->dec ( n b )
  (if (= 1 (setq l (length n)))
      (- (string-to-char n) (if (< (string-to-char n) 65) 48 55))
    (+ (* (expt b (1- l)) (base->dec (substring n 0 1) b)) (base->dec (substring n l) b))
    )
  )

(defun base->base ( n b1 b2 )
  (dec->base (base->dec n b1) b2)
  )

(defun base_convert ()
  "Interactive function to convert between number formats"
  (interactive)
  (setq n (read-string "Enter number:"))
  (setq b1 (string-to-number (read-string "Enter starting base:")))
  (setq b2 (string-to-number (read-string "Enter ending base:")))
  (print (base->base n b1 b2))
  )


;; ----------------------------------------------------------------------
;; Verilog Mode Extensions
;; ----------------------------------------------------------------------

(defun verilog-insert-string-newline (string &optional num)
  "Inserts a string, indents it and adds a newline.  Optionally adds num newlines"
  (interactive)
  (insert string)
  (electric-verilog-terminate-line)
  (if num (dotimes (n num)
	    (newline)) )
  )


(defun verilog-insert-divider (&optional comment)
  "Insert a comment divider"
  (interactive)
  (setq divider (concat "// " (make-string 70 ?-)))
  (verilog-indent-line)
  (verilog-insert-string-newline divider)
  (verilog-insert-string-newline (if comment (concat "// " comment) "// "))
  (verilog-insert-string-newline divider 2)
  )


(defun verilog-insert-module ()
  "Insert a Verilog module ... endmodule; block in the code with right indentation."
  (interactive)
  (setq start (point))
  (setq moduleName (read-string "Enter module name:"))
  (verilog-insert-string-newline (concat "module " moduleName " (/*AUTOARG*/);") 2)
  (dolist (item '("Parameters" "I/O Declarations" "Reg/Wire Declarations" "Main Code"))
    (verilog-insert-divider item))
  (verilog-insert-string-newline "endmodule" 1)
  (verilog-insert-string-newline "// Local Variables:")
  (verilog-insert-string-newline "// verilog-library-directories:(\".\")")
  (verilog-insert-string-newline "// End:" 2)
  )

(defun verilog-insert-dff ()
  "Insert a Verilog D-type FF"
  (interactive)
  (setq start (point))
  (setq registerName (read-string "Enter register name:"))
  (verilog-insert-string-newline "always@(posedge clk)")
  (verilog-insert-string-newline (concat "if(" registerName "_en)"))
  (verilog-insert-string-newline (concat registerName "_r <= " registerName "_nxt;"))
  )

(defun verilog-insert-dffr ()
  "Insert a Verilog D-type FF with async reset"
  (interactive)
  (setq start (point))
  (setq registerName (read-string "Enter register name:"))
  (verilog-insert-string-newline "always@(posedge clk or negedge reset_n)")
  (verilog-insert-string-newline "if(!reset_n)")
  (verilog-insert-string-newline (concat registerName "_r <= {{1'b0}};"))
  (verilog-insert-string-newline "else")
  (verilog-insert-string-newline (concat "if(" registerName "_en)"))
  (verilog-insert-string-newline (concat registerName "_r <= " registerName "_nxt;"))
  )
