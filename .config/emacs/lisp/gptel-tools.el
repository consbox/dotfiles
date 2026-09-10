;;; gptel-tools.el --- ... -*- lexical-binding: t -*-

(require 'gptel)

;;; TODO: where are things like path name and so on

(gptel-make-tool
 :name "config_paths"
 :function (lambda (config-name)
	     (cond ((equal "emacs" config-name) ("~/.config/emacs/"))))
 :description "get path name the use might mention"
 :args (list '(:name "config-name"
		     :type string
		     :description "Key word for a config")))

;;; emacs tools

;;; TODO: write_buffer (create if not exists)
;;; TODO: switch to buffer

(gptel-make-tool
 :name "read_buffer"                    ; javascript-style snake_case name
 :function (lambda (buffer)		; the function that will run
             (unless (buffer-live-p (get-buffer buffer))
               (error "error: buffer %s is not live." buffer))
             (with-current-buffer  buffer
               (buffer-substring-no-properties (point-min) (point-max))))
 :description "return the contents of an emacs buffer"
 :args (list '(:name "buffer"
		     :type string	; :type value must be a symbol
		     :description "the name of the buffer whose contents are to be retrieved"))
 :category "emacs")                     ; An arbitrary label for grouping

;;; filesystem tools

;;; TODO: create directory (error if exists)
;;; TODO: grep home for stuff
;;; TODO: open_file in buffer (find-file)

(gptel-make-tool
 :name "create_file"			   ; javascript-style  snake_case name
 :function (lambda (path filename content) ; the function that runs
             (let ((full-path (expand-file-name filename path)))
               (with-temp-buffer
                 (insert content)
                 (write-file full-path))
               (format "Created file %s in %s" filename path)))
 :description "Create a new file with the specified content"
 :args (list '(:name "path"             ; a list of argument specifications
		     :type string
		     :description "The directory where to create the file")
             '(:name "filename"
		     :type string
		     :description "The name of the file to create")
             '(:name "content"
		     :type string
		     :description "The content to write to the file"))
 :category "filesystem")                ; An arbitrary label for grouping

;; (file-exists-p "~/.sbclrc")
(gptel-make-tool
 :name "find_file"
 :function (lambda (path)
	     (if (file-exists-p path)
		 (find-file path)
	       (error "file does not exist: %s" path)))
 :description "open file in new buffer or open buffer if file is already open."
 :args (list '(:name "path"
		     :type string
		     :description "The path to the file.."))
 :category "filesystem")


;;; time tools

(gptel-make-tool
 :name "current_time"
 :function (lambda ()
	     (format-time-string "%Y-%m-%dT%H:%M:UTC%z"))
 :description "Get current real-time clock data (use 24h time)"
 :category "time")


(provide 'gptel-tools)
