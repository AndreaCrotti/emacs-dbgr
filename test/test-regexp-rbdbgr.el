(require 'test-unit)
(load-file "../dbgr/common/init/rbdbgr.el")

(test-unit-clear-contexts)


(setq bps    (gethash "brkpt-set" rbdbgr-pat-hash))
(setq prompt (gethash "prompt"    rbdbgr-pat-hash))
(setq tb     (gethash "traceback" rbdbgr-pat-hash))

(defun tb-loc-match(text) 
  (string-match (dbgr-loc-pat-regexp tb) text)
)

(defun bp-loc-match(text) 
  (string-match (dbgr-loc-pat-regexp bps) text)
)

;; FIXME: we get a void variable somewhere in here when running
;;        even though we define it in lexical-let. Dunno why.
;;        setq however will workaround this.
(setq text "	from /usr/local/bin/irb:12:in `<main>'")
(context "traceback location matching"
	 (tag regexp-rbdbgr)
	 (lexical-let ((text "	from /usr/local/bin/irb:12:in `<main>'"))
	   (specify "basic traceback location"
		    (assert-t (numberp (tb-loc-match text))))
	   (specify "extract traceback file name"
	   	    (assert-equal "/usr/local/bin/irb"
				  (match-string (dbgr-loc-pat-file-group tb)
	   				  text)))
	   (specify "extract traceback line number"
	   	    (assert-equal "12"
				  (match-string (dbgr-loc-pat-line-group tb)
						text)))
	   )

	   (specify "prompt"
	   	    (assert-equal 0 (string-match (dbgr-loc-pat-regexp prompt)
						  "(rbdbgr): "))
	   	    (assert-equal 0 (string-match (dbgr-loc-pat-regexp prompt)
						  "((rbdbgr)): "))
	   	    (assert-equal 0 (string-match (dbgr-loc-pat-regexp prompt)
						  "((rbdbgr@55)): "))
	   	    (assert-equal 0 (string-match (dbgr-loc-pat-regexp prompt)
						  "((rbdbgr@main)): "))
		    )


	 (lexical-let ((text "Breakpoint 1 set at line 9
	in file /usr/local/bin/irb,
	VM offset 2 of instruction sequence <top (required)>."))
	   (specify "basic breakpoint location"
		    (assert-t (numberp (bp-loc-match text))))
	   (specify "extract breakpoint file name"
	   	    (assert-equal "/usr/local/bin/irb"
				  (match-string (dbgr-loc-pat-file-group bps)
	   				  text)))
	   (specify "extract breakpoint line number"
	   	    (assert-equal "9"
				  (match-string (dbgr-loc-pat-line-group bps)
						text)))
	   )
	 )

(test-unit "regexp-rbdbgr")

