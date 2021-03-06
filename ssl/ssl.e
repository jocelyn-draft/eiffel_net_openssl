note
	description:	"SSL context"
	legal:			"See notice at end of class"
	status:			"See notice at end of class"
	date:			"$Date$"
	revision:		"$Revision$"

class
	SSL

inherit
	SSL_SHARED

create
	make_from_context

feature {NONE} -- Initialization

	make_from_context (a_ctx_ptr: POINTER)
			-- Create an SSL structure from the given `a_ctx_ptr'
		require
			a_ctx_ptr_valid: a_ctx_ptr /= default_pointer
		do
				--| Initialize SSL, as this may be one of the entry points into SSL where it is
				--| useful to initialize the SSL Library
			initialize_ssl

			ptr := c_ssl_new (a_ctx_ptr)
		end

feature -- Access

	accept
			-- Accept the SSL Socket
		local
			err: INTEGER
		do
			err := c_ssl_accept (ptr)
		end

	connect
			-- Connect the SSL Socket
		local
			err: INTEGER
			ssl_err: INTEGER_64
			l_string: STRING
		do
			err := c_ssl_connect (ptr)
			io.error.putstring ("c_ssl_connect returned ")
			io.error.putint (err)
			io.error.putstring ("%N")
			if err = -1 then
				ssl_err := c_err_get_error
				create l_string.make_from_c (c_err_error_string (ssl_err, default_pointer.item))
				io.error.putstring ("Reason: " + l_string + "%N")
				connected := False
			else
				connected := True
			end
		end

	free
			-- Free the underlying SSL Structure
		do
			c_ssl_free (ptr)
		end

	set_fd (an_fd: INTEGER)
			-- Set the SSL Socket File Descriptor to `an_fd'
		do
			c_ssl_set_fd (ptr, an_fd)
		end

	shutdown
			-- Shutdown the SSL Socket
		do
			c_ssl_shutdown (ptr)
		end

feature -- Input

	read (a_pointer: POINTER; nb_bytes: INTEGER): INTEGER
			-- Read at most `nb_bytes' into `a_pointer' from this SSL socket
		do
			Result := c_ssl_read (ptr, a_pointer, nb_bytes)
		end

feature -- Output

	write (a_pointer: POINTER; nb_bytes: INTEGER)
			-- Write the first `nb_bytes' from `a_pointer' onto this SSL socket
		local
			err: INTEGER
		do
			err := c_ssl_write (ptr, a_pointer, nb_bytes)
		end

feature -- Status Report

	connected: BOOLEAN
			-- Is the underlying SSL Socket connected?

feature {NONE} -- Implementation

feature {NONE} -- Attributes

	ptr: POINTER
			-- External SSL structure

feature {NONE} -- Externals

	c_err_error_string (ssl_err: INTEGER_64; buf_ptr: POINTER): POINTER
			-- External call to ERR_error_string
		external
			"C use <openssl/err.h>"
		alias
			"ERR_error_string"
		end

	c_err_get_error: INTEGER_64
			-- External call to ERR_get_error
		external
			"C use <openssl/err.h>"
		alias
			"ERR_get_error"
		end

	c_ssl_accept (an_ssl_ptr: POINTER): INTEGER
			-- External call to SSL_accept
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_accept"
		end

	c_ssl_connect (an_ssl_ptr: POINTER): INTEGER
			-- External call to SSL_connect
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_connect"
		end

	c_ssl_free (an_ssl_ptr: POINTER)
			-- External call to SSL_free
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_free"
		end

	c_ssl_new (a_ctx_ptr: POINTER): POINTER
			-- External call to SSL_new
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_new"
		end

	c_ssl_read (an_ssl_ptr: POINTER; buffer: POINTER; nb_bytes: INTEGER): INTEGER
			-- External call to SSL_read
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_read"
		end

	c_ssl_set_fd (a_ctx_ptr: POINTER; an_fd: INTEGER)
			-- External call to SSL_set_fd
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_set_fd"
		end

	c_ssl_shutdown (an_ssl_ptr: POINTER)
			-- External call to SSL_shutdown
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_shutdown"
		end

	c_ssl_write (an_ssl_ptr: POINTER; buffer: POINTER; nb_bytes: INTEGER): INTEGER
			-- External call to SSL_write
		external
			"C use <openssl/ssl.h>"
		alias
			"SSL_write"
		end

note
	copyright:	"Copyright (C) 2010 by ITPassion Ltd, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source:		"[
					ITPassion Ltd
					5 Anstice Close, Chiswick, Middlesex, W4 2RJ, United Kingdom
					Telephone +44 208 742 3422, Fax +44 208 742 3468
					Website http://www.itpassion.com
					Customer support https://powerdesk.itpassion.com
				]"

end

