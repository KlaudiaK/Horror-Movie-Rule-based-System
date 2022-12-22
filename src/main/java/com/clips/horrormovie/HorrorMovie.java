package com.clips.horrormovie;

import net.sf.clipsrules.jni.*;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileNotFoundException;
import java.net.URL;
import java.text.BreakIterator;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

public class HorrorMovie implements ActionListener {
    JLabel displayLabel;
    JButton nextButton;
    JButton prevButton;
    JPanel choicesPanel;
    ButtonGroup choicesButtons;
    ResourceBundle autoResources;

    Environment clips;
    boolean isExecuting = false;
    Thread executionThread;

    Color backgroundColor = new Color(0xFFBFD4EC);
    Color buttonBackgroundColor = new Color(0x7094AC);
    HorrorMovie() throws FileNotFoundException, CLIPSException {
        try {
            this.autoResources = ResourceBundle.getBundle("properties.HorrorMovie",
                    Locale.getDefault());
        } catch (MissingResourceException mre) {
            mre.printStackTrace();
            return;
        }

        final JFrame jfrm = new JFrame(this.autoResources.getString("HorrorMovie"));

        jfrm.getContentPane().setLayout(new GridLayout(3, 1));

        jfrm.setSize(700, 400);

        jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);


        final JPanel displayPanel = new JPanel();
        this.displayLabel = new JLabel();
        displayPanel.add(this.displayLabel);
        displayPanel.setBackground(backgroundColor);
        displayPanel.setOpaque(true);

        this.choicesPanel = new JPanel();
        this.choicesPanel.setBackground(backgroundColor);
        this.choicesPanel.setOpaque(true);
        this.choicesButtons = new ButtonGroup();

        displayPanel.setOpaque(true);

        final JPanel buttonPanel = new JPanel();
        buttonPanel.setSize(200, 100);
        buttonPanel.setBackground(backgroundColor);
        buttonPanel.setOpaque(true);
        this.prevButton = new JButton(autoResources.getString("Prev"));
        this.prevButton.setActionCommand("Prev");
        this.prevButton.setBackground(buttonBackgroundColor);
        this.prevButton.setOpaque(true);
        this.prevButton.setPreferredSize(new Dimension(100, 40));
        this.prevButton.setFont(new Font("Serif", Font.PLAIN, 20));
        buttonPanel.add(prevButton);
        this.prevButton.addActionListener(this);

        this.nextButton = new JButton(autoResources.getString("Next"));
        this.nextButton.setActionCommand("Next");
        this.nextButton.setBackground(buttonBackgroundColor);
        this.nextButton.setOpaque(true);
        this.nextButton.setPreferredSize(new Dimension(100, 40));
        this.nextButton.setFont(new Font("Serif", Font.PLAIN, 20));
        buttonPanel.add(nextButton);
        this.nextButton.addActionListener(this);

        jfrm.getContentPane().add(displayPanel);
        jfrm.getContentPane().add(choicesPanel);
        jfrm.getContentPane().add(buttonPanel);

        this.clips = new Environment();

        this.clips.load("horrormovie.clp");

        this.clips.reset();
        runProgram();

        jfrm.setVisible(true);
    }

    private String getFilePath(String filename) throws FileNotFoundException {
        final URL url = Thread.currentThread().getContextClassLoader().getResource(filename);
        if (url == null) throw new FileNotFoundException("\"" + filename + "\" does not exist.");
        return url.getPath();
    }

    private FactAddressValue findFirstFact(String evalStr) throws CLIPSException {
        final MultifieldValue results = (MultifieldValue) this.clips.eval(evalStr);
        return (FactAddressValue) results.get(0);
    }

    private void nextUIState() throws ClassCastException, CLIPSException {

        /* Get the state-list. */

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
        final String currentID = findFirstFact(evalStr).getSlotValue("current").toString();

        /* Get the current UI state. */

        evalStr = "(find-all-facts ((?f UI-state)) " + "(eq ?f:id " + currentID
                + "))";
        final FactAddressValue fv = findFirstFact(evalStr);

        /* Determine the Next/Prev button states. */

        if (fv.getSlotValue("state").toString().equals("final")) {
            this.nextButton.setActionCommand("Restart");
            this.nextButton.setText(this.autoResources.getString("Restart"));
            this.prevButton.setVisible(true);
        } else if (fv.getSlotValue("state").toString().equals("initial")) {
            this.nextButton.setActionCommand("Next");
            this.nextButton.setText(this.autoResources.getString("Next"));
            this.prevButton.setVisible(false);
        } else {
            this.nextButton.setActionCommand("Next");
            this.nextButton.setText(this.autoResources.getString("Next"));
            this.prevButton.setVisible(true);
        }

        /* Set up the choices. */

        this.choicesPanel.removeAll();
        this.choicesButtons = new ButtonGroup();

        final MultifieldValue pv = (MultifieldValue) fv.getSlotValue("valid-answers");

        final String selected = fv.getSlotValue("response").toString();

        for (int i = 0; i < pv.size(); i++) {
            final PrimitiveValue bv = pv.get(i);
            final JRadioButton rButton;

            if (bv.toString().equals(selected)) {
                rButton = new JRadioButton(autoResources.getString(bv
                        .toString()), true);
            } else {
                rButton = new JRadioButton(autoResources.getString(bv
                        .toString()), false);
            }
            rButton.setFont(new Font("Serif", Font.PLAIN, 18));
            rButton.setBackground(backgroundColor);
            rButton.setOpaque(true);
            rButton.setActionCommand(bv.toString());
            this.choicesPanel.add(rButton);
            this.choicesButtons.add(rButton);
        }

        this.choicesPanel.repaint();

        /* Set the label to the display text. */

        final String symbolVal = ((SymbolValue) fv.getSlotValue("display")).getValue();
        final String theText = this.autoResources.getString(symbolVal);

        wrapLabelText(this.displayLabel, theText);

        this.executionThread = null;
        this.isExecuting = false;
    }

    /* ActionListener Methods */

    public void actionPerformed(ActionEvent ae) {
        try {
            onActionPerformed(ae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void runProgram() {
        final Runnable runThread = new Runnable() {
            public void run() {
                try {
                    clips.run();
                } catch (CLIPSException e) {
                    e.printStackTrace();
                }

                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        try {
                            nextUIState();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });
            }
        };

        this.isExecuting = true;

        this.executionThread = new Thread(runThread);

        this.executionThread.start();
    }

    public void onActionPerformed(ActionEvent ae) throws ClassCastException, CLIPSException {
        if (this.isExecuting)
            return;

        /* Get the state-list. */

        final String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
        final String currentID = findFirstFact(evalStr).getSlotValue("current").toString();

        /* Handle the Next button. */

        if (ae.getActionCommand().equals("Next")) {
            if (choicesButtons.getButtonCount() == 0) {
                this.clips.assertString("(next " + currentID + ")");
            } else {
                this.clips.assertString("(next " + currentID + " "
                        + choicesButtons.getSelection().getActionCommand()
                        + ")");
            }

            runProgram();
        } else if (ae.getActionCommand().equals("Restart")) {
            this.clips.reset();
            runProgram();
        } else if (ae.getActionCommand().equals("Prev")) {
            this.clips.assertString("(prev " + currentID + ")");
            runProgram();
        }
    }

    private void wrapLabelText(JLabel label, String text) {
        label.setFont(new Font("Serif", Font.BOLD, 22));
        label.setBorder(new EmptyBorder(20,0,0,0));
        final FontMetrics fm = label.getFontMetrics(label.getFont());
        final Container container = label.getParent();
        int containerWidth = container.getWidth();
        int textWidth = SwingUtilities.computeStringWidth(fm, text);
        int desiredWidth;

        if (textWidth <= containerWidth) {
            desiredWidth = containerWidth;
        } else {
            int lines = (int) ((textWidth + containerWidth) / containerWidth);

            desiredWidth = (int) (textWidth / lines);
        }

        final BreakIterator boundary = BreakIterator.getWordInstance();
        boundary.setText(text);

        StringBuffer trial = new StringBuffer();
        final StringBuffer real = new StringBuffer("<html><center>");

        int start = boundary.first();
        for (int end = boundary.next(); end != BreakIterator.DONE; start = end, end = boundary
                .next()) {
            final String word = text.substring(start, end);
            trial.append(word);
            int trialWidth = SwingUtilities.computeStringWidth(fm,
                    trial.toString());
            if (trialWidth > containerWidth) {
                trial = new StringBuffer(word);
                real.append("<br>");
                real.append(word);
            } else if (trialWidth > desiredWidth) {
                trial = new StringBuffer("");
                real.append(word);
                real.append("<br>");
            } else {
                real.append(word);
            }
        }

        real.append("</html>");

        label.setText(real.toString());
    }

    public static void main(String args[]) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                try {
                    new HorrorMovie();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
}