using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Projekt_BIAI.Model;
using RDotNet;
using RDotNet.NativeLibrary;

namespace Projekt_BIAI
{
    public partial class MainWindow : Form
    {
        /// <summary>
        /// Nasza instancja silnika R - może przyjmować wyrażenia w języku R lub odpalać gotowe skrypty
        /// </summary>
        private _REngine RConnector;

        /// <summary>
        /// True, jeśli podczas obliczeń wystąpił błąd
        /// </summary>
        //private bool errorOccured = false;

        public MainWindow()
        {
            InitializeComponent();

            RConnector = new _REngine();

            RConnector.Initialize();

        }

        private void MainWindow_Load(object sender, EventArgs e)
        {
            comboBox1.SelectedIndex = 0;
            panel1.Enabled = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            pictureBox1.Visible = true;
            label7.Visible = true;

            pictureBox1.Image = Projekt_BIAI.Properties.Resources.loading;
            label7.ForeColor = Color.Blue;
            label7.Text = "Trwa przetwarzanie...";

            try
            {
                RConnector.launchScript("ExtraColumns", false);

                if (comboBox1.SelectedIndex == 0)
                    backgroundWorker1.RunWorkerAsync("Forest2");
                else
                    backgroundWorker1.RunWorkerAsync("UserForest");

                button1.Enabled = false;
            }
            catch (EvaluationException)                 // Chyci tylko wyjątek z launchScripta
            {
                pictureBox1.Image = Projekt_BIAI.Properties.Resources.error;
                label7.ForeColor = Color.Red;
                label7.Text = "Wystąpił błąd!";
                //this.Close();
            }
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            if (e.Argument.Equals("Forest2"))
                RConnector.launchScript("Forest2", true, treeNumber.Value.ToString());

            else if (e.Argument.Equals("UserForest"))
            {
                RConnector.launchScript("UserForest", true, treeNumber.Value.ToString(),
                                                            numericUpDown1.Value.ToString(),
                                                            numericUpDown2.Value.ToString(),
                                                            numericUpDown3.Value.ToString(),
                                                            numericUpDown4.Value.ToString(),
                                                            numericUpDown5.Value.ToString());
            }
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            if (e.Error != null)                    // e.Error przechowuje informacje nt. wszelkich wyjątków, które zostały złapane
            {                                       // w wątku Background Worker'a
                pictureBox1.Image = Projekt_BIAI.Properties.Resources.error;
                label7.ForeColor = Color.Red;
                label7.Text = "Wystąpił błąd!";
            }
            else
            {
                pictureBox1.Image = Projekt_BIAI.Properties.Resources.OK;
                label7.ForeColor = Color.Green;
                label7.Text = "Przetwarzanie zakończone!";
            }

            button1.Enabled = true;
        }

        private void MainWindow_FormClosed(object sender, FormClosedEventArgs e)
        {
            RConnector.DisposeEngine();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            panel1.Enabled = (comboBox1.SelectedIndex == 0 ? false : true);
        }

        /// <summary>
        /// Określa w szer. i wys. geograficznej miejsce na które kliknął użytkownik.
        /// </summary>
        private void pictureBox2_Click(object sender, EventArgs e)
        {
            int cursorWidth = pictureBox2.PointToClient(Cursor.Position).X;
            int cursorHeight = pictureBox2.PointToClient(Cursor.Position).Y;

            float cursorLongitude = ((float)cursorWidth / pictureBox2.Width) * 360 - 180;
            float cursorLatitude = ((float)(pictureBox2.Height - cursorHeight) / pictureBox2.Height) * 180 - 75;    // -75, bo mapa niesymetryczna

            if (comboBox1.SelectedIndex == 1)
            {
                numericUpDown1.Value = (cursorLatitude < 90) ? (int)cursorLatitude : 90;
                numericUpDown2.Value = (int)cursorLongitude;
            }
        }
    }
}
