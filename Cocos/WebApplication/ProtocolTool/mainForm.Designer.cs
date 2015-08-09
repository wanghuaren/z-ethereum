namespace ProtocolTool
{
    partial class mainForm
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.btnTransCC = new System.Windows.Forms.Button();
            this.radioSQL = new System.Windows.Forms.RadioButton();
            this.radioAccess = new System.Windows.Forms.RadioButton();
            this.btnChoose = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtPath = new System.Windows.Forms.TextBox();
            this.textPathRes = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.btnCrypt = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnTransCC
            // 
            this.btnTransCC.Location = new System.Drawing.Point(80, 78);
            this.btnTransCC.Name = "btnTransCC";
            this.btnTransCC.Size = new System.Drawing.Size(101, 23);
            this.btnTransCC.TabIndex = 0;
            this.btnTransCC.Text = "C#<-->C++协议";
            this.btnTransCC.UseVisualStyleBackColor = true;
            this.btnTransCC.Click += new System.EventHandler(this.btnTransCC_Click);
            // 
            // radioSQL
            // 
            this.radioSQL.AutoSize = true;
            this.radioSQL.Location = new System.Drawing.Point(37, 42);
            this.radioSQL.Name = "radioSQL";
            this.radioSQL.Size = new System.Drawing.Size(83, 16);
            this.radioSQL.TabIndex = 1;
            this.radioSQL.Text = "sql server";
            this.radioSQL.UseVisualStyleBackColor = true;
            // 
            // radioAccess
            // 
            this.radioAccess.AutoSize = true;
            this.radioAccess.Checked = true;
            this.radioAccess.Location = new System.Drawing.Point(162, 42);
            this.radioAccess.Name = "radioAccess";
            this.radioAccess.Size = new System.Drawing.Size(59, 16);
            this.radioAccess.TabIndex = 2;
            this.radioAccess.TabStop = true;
            this.radioAccess.Text = "access";
            this.radioAccess.UseVisualStyleBackColor = true;
            // 
            // btnChoose
            // 
            this.btnChoose.Location = new System.Drawing.Point(202, 13);
            this.btnChoose.Name = "btnChoose";
            this.btnChoose.Size = new System.Drawing.Size(75, 23);
            this.btnChoose.TabIndex = 3;
            this.btnChoose.Text = "选择数据库";
            this.btnChoose.UseVisualStyleBackColor = true;
            this.btnChoose.Click += new System.EventHandler(this.btnChoose_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 18);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 12);
            this.label1.TabIndex = 4;
            this.label1.Text = "数据库路径";
            // 
            // txtPath
            // 
            this.txtPath.Location = new System.Drawing.Point(80, 13);
            this.txtPath.Name = "txtPath";
            this.txtPath.Size = new System.Drawing.Size(119, 21);
            this.txtPath.TabIndex = 5;
            // 
            // textPathRes
            // 
            this.textPathRes.Location = new System.Drawing.Point(80, 190);
            this.textPathRes.Name = "textPathRes";
            this.textPathRes.Size = new System.Drawing.Size(119, 21);
            this.textPathRes.TabIndex = 8;
            this.textPathRes.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 195);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(71, 12);
            this.label2.TabIndex = 7;
            this.label2.Text = "APP资源路径";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(202, 190);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 6;
            this.button1.Text = "APP资源";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnCrypt
            // 
            this.btnCrypt.Location = new System.Drawing.Point(93, 227);
            this.btnCrypt.Name = "btnCrypt";
            this.btnCrypt.Size = new System.Drawing.Size(75, 23);
            this.btnCrypt.TabIndex = 9;
            this.btnCrypt.Text = "加密";
            this.btnCrypt.UseVisualStyleBackColor = true;
            this.btnCrypt.Click += new System.EventHandler(this.btnCrypt_Click);
            // 
            // mainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 262);
            this.Controls.Add(this.btnCrypt);
            this.Controls.Add(this.textPathRes);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.txtPath);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnChoose);
            this.Controls.Add(this.radioAccess);
            this.Controls.Add(this.radioSQL);
            this.Controls.Add(this.btnTransCC);
            this.Name = "mainForm";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnTransCC;
        private System.Windows.Forms.RadioButton radioSQL;
        private System.Windows.Forms.RadioButton radioAccess;
        private System.Windows.Forms.Button btnChoose;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtPath;
        private System.Windows.Forms.TextBox textPathRes;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button btnCrypt;
    }
}

